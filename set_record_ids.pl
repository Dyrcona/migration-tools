#!/usr/bin/perl
use strict;
use warnings;

use MARC::Batch;
use Getopt::Long;
#use MARC::Record;
#use MARC::File::XML ( BinaryEncoding => 'utf-8' );
#use MARC::Field;

my $count = 0;
my $conf  = {}; # configuration hashref
initialize($conf);

binmode(STDOUT, ':utf8');
binmode(STDIN, ':utf8');

foreach my $input ( @ARGV ) {
    print STDERR "Processing $input, starting record id at ",
      $conf->{'renumber-from'},"\n";

    my $batch = MARC::Batch->new('XML', $input);
    while ( my $record = $batch->next ) {
        $count++;
        my @warnings = $batch->warnings;
        print STDERR "WARNINGS: Record $count : ",
          join(":",@warnings), " : continuing...\n"
            if ( @warnings );

        while ($record->field($conf->{tag}))
          { $record->delete_field( $record->field($conf->{tag}) ) }
        my $new_id = $conf->{'renumber-from'} + $count - 1;
        my $new_id_field = MARC::Field->new( $conf->{tag},
                                             ' ',
                                             ' ',
                                             $conf->{subfield} => $new_id );
        $record->append_fields($new_id_field);
        print $record->as_xml;
    }
    print STDERR "Processed $count records.  Last record id at ",
      ($conf->{'renumber-from'} + $count - 1), "\n";
}


=head2 initialize

Performs boring script initialization. Handles argument parsing,
mostly.

=cut

sub initialize {
    my ($c) = @_;
    my @missing = ();

    # set mode on existing filehandles
    binmode(STDIN, ':utf8');

    my $rc = GetOptions( $c,
                         'output|o=s',
                         'renumber-from|rf=i',
                         'subfield|s=s',
                         'tag|t=s',
                         'help|h',
                       );
    show_help() unless $rc;

    my @keys = keys %{$c};
    show_help() unless (@ARGV and @keys);
    for my $key ('renumber-from', 'tag', 'subfield', 'output')
      { push @missing, $key unless $c->{$key} }
    if (@missing) {
        print "Required option: ", join(', ', @missing), " missing!\n";
        show_help();
    }

    show_help() if ($c->{help});
}


=head2 show_help

Display usage message when things go wrong

=cut

sub show_help {
print <<HELP;
Usage is: $0 [REQUIRED ARGS] <filelist>
Req'd Arguments
  --renumber-from=N        -rf First id# of new sequence
  --tag=N                  -t  Which tag to use
  --subfield=X             -s  Which subfield to use
  --output=<file>          -o  Output filename

Any number of input files may be specified; one output file will result.
HELP
exit 1;
}
