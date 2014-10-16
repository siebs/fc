#!/bin/perl -w

use DBD::Oracle qw(::ora_session_modes); # Initialize w/ capabilities for SYSDBA, etc.
use DBI;

$dbh = DBI->connect('dbi:Oracle:DBSID','username','password') 
	or die "Couldn't connect to database: " . DBI->errstr;

#  Valid alternatives
# $dbh = DBI->connect('dbi:Oracle:DB','username/password','');
# $dbh = DBI->connect('dbi:Oracle:','username@DB','password');
# $dbh = DBI->connect('dbi:Oracle:host=foobar;sid=DB;port=1521', 'scott/tiger', '');
# $dbh = DBI->connect("dbi:Oracle://myhost:1522/ORCL",'username', 'password');

#  Ping test the handle
$rv = $dbh->ping;

#  SQL statement w/ BIND
$SQL="select * from foo where status = ?";

#  Prep it  
$sth = $dbh->prepare($SQL) 
	or die "Couldn't prepare statement: " . $dbh->errstr;

#  BIND it
$sth->bind_param(1,'VALID') or die "Could not BIND";

# Execute the query
$sth->execute($SQL)             
            or die "Couldn't execute statement: " . $sth->errstr;
			
# Read the matching records and print them out          
while (@data = $sth->fetchrow_array()) {
	my $id = $data[1];
	my $name = $data[2];
	print "\t$id: $id $name\n";
}

#  Test for empty result set
if ($sth->rows == 0) {
	print "Nothing matched VALID status\n\n";
}

#  END
$sth->finish;






