#!/usr/bin/perl

use strict;
use warnings;

# copy and paste raw text from acrobat reader to .txt file

my $filename = $ARGV[0];
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

my $user;

print "user\titem\trequested\texpire\n";
 
while (my $row = <$fh>) {
  chomp $row;
  $row =~ s/ +/ /g;
  if ($row =~ m/Items On Hold by Patron/) { next; }
  if ($row =~ m/Patron Title Barcode /) { next; }
  if ($row =~ m/Page: /) { next; }
  if ($row =~ m/Program Files \(x86\)/) { next; }
  if ($row =~ m/End Of Report/) { last; }
  if ($row =~ m/^$/) { next; }
  my @str = split / /, $row;
  my $str_length = scalar(@str);
  if ($str[1] eq 'AM' or $str[1] eq 'PM') { next; }


  if ($str[$str_length -1] !~ m/\d\d\/\d\d\/\d\d\d\d/) {
    $user = $str[$str_length -1];
    next;
  }

  if ($str[$str_length -1] =~  m/\d\d\/\d\d\/\d\d\d\d/) {
    my $posted    = $str[$str_length -1];  
    my $expire    = $str[$str_length -2];  
    my $item      = $str[$str_length -3];  #item
    print "$user\t$item\t$posted\t$expire\n";
  } 
}
