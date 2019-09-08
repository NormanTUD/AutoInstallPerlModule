#!/usr/bin/perl

use strict;
use warnings;
use lib '.';
use AutoInstallPerlModule;

use Test::ISBN; # Not installed by default
use Geo::Coder::Google; # Not installed by default
use AI::NeuralNet::BackProp; # Not installed by default
use POSIX qw(setsid); # Installed

print "hallo welt\n";
