use inc::Module::Install;

all_from    "lib/DBICx/Schema/HasFK.pm";

requires    "DBIx::Class"   => 0;
requires    "Clone"         => 0;
requires    "Lingua::EN::Inflect::Number"   => 0;

WriteAll;
