package AutoInstallPerlModule;

use strict;
use warnings;
use Filter::Simple;
use CPAN;
use Carp;

use Data::Dumper;

FILTER {
	_install_uninstalled_modules_from_string($_);
	return $_;
};

sub _install_uninstalled_modules_from_string {
	my $string = shift;

	my @uninstalled_modules = _get_uninstalled_modules_from_string($string);

	foreach my $module (@uninstalled_modules) {
		if(_is_root()) {
			CPAN::Shell->install($module);
		} else {
			confess "You must be root!";
			exit(1);
		}
	}
}

sub _is_root {
	my $login = (getpwuid $>);
	if($login eq 'root') {
		return 1;
	} else {
		return 0;
	}
}

sub _get_uninstalled_modules_from_string {
	my $string = shift;
	my @modules = _get_modules_from_string($string);

	my @uninstalled_modules = ();
	foreach my $module (@modules) {
		eval "use $module;";
		if($@) {
			push @uninstalled_modules, $module;
		}
	}
	return @uninstalled_modules;
}

sub _get_modules_from_string {
	my $string = shift;

	my @modules = ();

	while ($string =~ m#\buse\s+([A-Za-z0-9_:]+)(\b\s*(\s+.*))?;#gism) {
		push @modules, $1;
	}

	return @modules;
}

1;
