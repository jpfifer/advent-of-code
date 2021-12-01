#!/usr/local/bin/perl
use strict;
use warnings FATAL => 'all';

use English;
use Getopt::Long;
use Carp;

my $input_file_name;
my $window_size = 1;
GetOptions(
  "file-name=s"   => \$input_file_name,
  "window-size=n" => \$window_size
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

sub sum_window {
  my @win = @_;
  my $res = 0;
  for my $val (@win) {
    $res += $val
  }
}

sub window_data {
  my ($ws, @data) = @_;

  my @window;
  my $current = 0;
  my @result;
  for my $ms (@data) {
    if ($#window > $ws) {
      my $last = shift @window;
      push @result, $current;
      $current -= $last;
    }
    $current += $ms;
    push @window, $ms;
  }
  push @result, $current;
  return @result;
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
my @windowed = window_data($window_size, @measurements);

my $increases = count_diffs(@windowed);

print("Increases: $increases\n");
