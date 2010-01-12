package DBICx::Schema::HasFK;

use strict;
use warnings;

use Carp;
use Data::Dump qw/dump/;
use Devel::Peek;

use Clone ();
use Lingua::EN::Inflect ();

my $PL = \&Lingua::EN::Inflect::PL;

sub has_fk {
    my ($class, $col, $fkc, $hm, $attrs) = @_;

    my @pk = $fkc->primary_columns
        or croak "$fkc has no PK";
    @pk == 1
        or croak "$fkc\'s PK has " . @pk . " cols";
    my $pk = $pk[0];

    my $fki = Clone::clone $fkc->column_info($pk);
    delete $fki->{is_auto_increment};

    $class->add_columns($col, $fki);
    $class->belongs_to($col, $fkc, $attrs);
    $hm and do {
        $fkc->has_many($hm, $class, $col);
    };
}

sub make_link_entity {
    my ($class, $mtm, $onecls, $onecol, $twocls, $twocol) = @_;

    my $onei = Clone::clone $onecls->column_info($onecol);
    delete $onei->{is_auto_increment};
    my $twoi = Clone::clone $twocls->column_info($twocol);
    delete $twoi->{is_auto_increment};

    $class->add_columns($onecol, $onei, $twocol, $twoi);
    $class->set_primary_key($onecol, $twocol);
    $class->belongs_to($onecol, $onecls);
    $class->belongs_to($twocol, $twocls);
    $onecls->has_many($mtm, $class, $onecol);
    $twocls->has_many($mtm, $class, $twocol);
    $onecls->many_to_many("${twocol}s", $class, $twocol);
    $twocls->many_to_many("${onecol}s", $class, $onecol);
}

1;

