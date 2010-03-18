#!/usr/bin/perl -w
# -*- coding: utf-8 -*-
#
# # Author: simula67 <simula67@gmail.com>
# Thanks to h4nnibal<arjun1296@gmail.com> and dhananjay<mb.dhananjay@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Library General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA


###########################################################################################
#  CAUTION: This was intended to run on a solaris server (5.10)                           #
# Dependencies :1)File::Path								  #
#	      	2)LWP::Simple  								  #
#	      	3)zcat               							  #
###########################################################################################

use File::Path;
use LWP::Simple;
###########################
# Configuration Variables #
###########################

#This needs to be set to the URL of the mirror
my $url ="192.168.2.6/repo";


#This is the local directory to which the mirror is mirrored
my $mirror_dir = "/home/simula67/mirror";

#Protocol that needs to be followed
my $proto = "http"; # or ftp

#The distributions that needs to be mirrored
my @dists = ('karmic','karmic-backports','karmic-security','karmic-updates');

#Repositories that needs to be mirrored
my @repos = ('main','multiverse','universe','restricted');

#Architectures that needs to be mirrored
my @archs = ('binary-i386');



#################
#   Main Loop   #
#################

foreach $cur_dist (@dists) {
    foreach $cur_repo (@repos) {
	foreach $cur_arch (@archs) {
	    mkpath("$mirror_dir/dists/$cur_dist/$cur_repo/$cur_arch");
	    $CWD = "$mirror_dir/dists/$cur_dist/$cur_repo/$cur_arch";
	    unless (getstore("$proto://$url/dists/$cur_dist/$cur_repo/$cur_arch/Packages.gz","$CWD/Packages.gz")==RC_OK) {
		warn "Failed to fecth unless Packages.gz for $cur_dist,$cur_repo,$cur_arch";
		next;
	    }
	    system("zcat $CWD/Packages.gz>Packages");
	    open FILELIST,"<Packages" or die "Cant open the file";
	    my $file_url;
	    my $target_dir;
	    my $target_file;
	    my $file_name;
	    while(<FILELIST>) {
		chomp;
		unless(m/^Filename: (\S*)/){
		    next;
		}
		$file_url = "$url/$1";
		$target_file=$1;
		($target_dir,$file_name) = ( $1 =~ m/(\S*)\/(\S*)/);
		mkpath("$mirror_dir/$target_dir/");
		unless(mirror("$proto://$file_url","$mirror_dir/$target_file")==RC_OK) {
		    warn "Failed to mirror $cur_dist,$cur_repo,$cur_arch : $file_name";
		}
		else {
		    print "Done : $cur_dist,$cur_repo,$cur_arch : $file_name\n";
		}
	    }
	    unlink("Packages");
	}
    }
}

