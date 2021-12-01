#!/usr/local/bin/perl
use strict;
use warnings FATAL => 'all';

use English;
use Getopt::Long;
use Carp;

my $input_file_name = '';
GetOptions(
  "file-name=s" => \$input_file_name
) or die("Failed to get options");

croak("File $input_file_name doesn't exist") unless -f $input_file_name;

sub load_file {
  my ($file_name) = @_;

  open my $input_file, '<', $file_name or croak "Failed to open $file_name: $ERRNO";
  my @input;
  while (<$input_file>) {
    chomp;
    push @input, $_;
  }
  close $input_file;

  return @input;
}

sub count_diffs {
  my @measures = @_;
  my $last = undef;
  my $increases = 0;
  for my $measure (@measures) {
    if (defined $last) {
      $increases++ if $measure > $last;
    }
    $last = $measure;
  }
  return $increases;
}

my @measurements = load_file($input_file_name);

my $increases = count_diffs(@measurements);

print("Increases: $increases\n");
