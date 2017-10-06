package DAO::ConnectionDao;
use strict;
use warnings;
<<<<<<< HEAD
use Exporter qw(import);
=======
>>>>>>> tchirila/master
use DBI;
use lib '..';
use Exporter qw(import);

my @EXPORT_OK = qw(getDbConnection closeDbConnection); 

$|=1;


our $DB_CREDENTIALS_FILE = 'C:\j2ee_vaadin_test_workspace\PerlFDM\pensionScheme\dataFiles\dbcreds.txt'; # TODO need to find from relative path
our $CORRUPT_DB_PROP_FILE_MSG = "Database file $DB_CREDENTIALS_FILE";  

# create and return a new databae conenction
sub getDbConnection()
{
	my $dbName;
	my $dbUsername;
	my $dbPass;
	my $dbPort;
	my $dbServer;
	
	print "\nReading $CORRUPT_DB_PROP_FILE_MSG\n";
	open(DB_INPUT, $DB_CREDENTIALS_FILE) or die("$CORRUPT_DB_PROP_FILE_MSG could not be found");
	
	my @data;
	LINE: while(my $line = <DB_INPUT>)                
	{
		# if line is blank or starts with "#", skipt the line
		$line =~ /\S+|^\#/ or next; 
		chomp $line;  
		
		# get key / value content for line		
		my @lineProps = split(/\s*=\s*/, $line); 
		if (@lineProps != 2) 
		{
			next;
		}
	
		# load db property
		my $key = $lineProps[0];
		if ($key eq "db_name")
		{
			$dbName = $lineProps[1];
			$dbName =~ s/^\s+|\s+$//g;
		}
	    if ($key eq "db_username")
		{
			$dbUsername = $lineProps[1];
		}	
	    if ($key eq "db_pass")
		{
			$dbPass = $lineProps[1];
		}	
	    if ($key eq "db_port")
		{
			$dbPort = $lineProps[1];
		}	
	    if ($key eq "db_server") 
		{
			$dbServer = $lineProps[1];	
		}	
	}
	
	close DB_INPUT; 	
	
	# create the connection
	if (isValid($dbName, $dbUsername, $dbPass, $dbPort, $dbServer))
	{
		my $url = "dbi:mysql:pensions"; # TODO could make this more flexible
		my $dbHandle = DBI-> connect($url, $dbUsername, $dbPass);
		unless(defined($dbHandle))
		{
			die("\nCould not access database\n");
		}	
		
		print "\nConnected successfully to database: $dbName\n";
	}
	else
	{
		die ($CORRUPT_DB_PROP_FILE_MSG . "is invalid");
	}
}	



# ensure adequate db credentials have been supplied
sub isValid()
{
    my ($dbName, $dbUsername, $dbPass, $dbPort, $dbServer) = @_;
	if (defined($dbName) && defined($dbUsername) 
			&& defined($dbPass) && defined($dbServer))
	{
		return 1;
	}    

	return 0;	

}


# close an existing database connection
sub closeDbConnection()
{
	my $dbHandle = shift;  
	unless(defined($dbHandle))
	{
		print "\nConnection closed\n";
		close($dbHandle);
	}
}


