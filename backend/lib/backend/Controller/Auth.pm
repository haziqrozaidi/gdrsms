package GDRSMS::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';
use DBI;
use Digest::SHA qw(sha256_hex);

sub register {
    my $self = shift;

    # Get registration data
    my $data = $self->req->json;

    # Validate required fields
    my @required_fields = qw(username full_name email password user_type);
    foreach my $field (@required_fields) {
        unless (exists $data->{$field} && $data->{$field}) {
            return $self->render(
                json => { 
                    status => 'error', 
                    message => "Missing required field: $field" 
                }, 
                status => 400
            );
        }
    }

    # Database connection
    my $dbh = DBI->connect(
        "dbi:mysql:database=GDRSMS", 
        'username', 
        'password',
        { RaiseError => 1, AutoCommit => 0 }
    );

    eval {
        # Check if username or email already exists
        my $check_sth = $dbh->prepare(
            "SELECT 1 FROM User WHERE username = ? OR email = ?"
        );
        $check_sth->execute($data->{username}, $data->{email});
        
        if ($check_sth->fetchrow_array) {
            die "Username or email already exists";
        }

        # Hash the password
        my $hashed_password = sha256_hex($data->{password});

        # Insert into User table
        my $user_sth = $dbh->prepare(
            "INSERT INTO User (username, full_name, email, password, contact_no, faculty) " .
            "VALUES (?, ?, ?, ?, ?, ?)"
        );
        $user_sth->execute(
            $data->{username}, 
            $data->{full_name}, 
            $data->{email}, 
            $hashed_password,
            $data->{contact_no},
            $data->{faculty}
        );

        # Get the last inserted user_id
        my $user_id = $dbh->last_insert_id(undef, undef, undef, undef);

        # Insert into specific user type table
        if ($data->{user_type} eq 'student') {
            my $student_sth = $dbh->prepare(
                "INSERT INTO Student (user_id, matric_no) VALUES (?, ?)"
            );
            $student_sth->execute($user_id, $data->{matric_no});
        }
        elsif ($data->{user_type} eq 'lecturer') {
            my $lecturer_sth = $dbh->prepare(
                "INSERT INTO Lecturer (user_id, staff_no) VALUES (?, ?)"
            );
            $lecturer_sth->execute($user_id, $data->{staff_no});
        }

        # Commit transaction
        $dbh->commit;

        # Render success response
        $self->render(
            json => { 
                status => 'success', 
                message => 'User registered successfully',
                user_id => $user_id 
            }
        );
    };

    # Handle any errors
    if ($@) {
        $dbh->rollback;
        $self->render(
            json => { 
                status => 'error', 
                message => $@ 
            }, 
            status => 400
        );
    }

    # Close database connection
    $dbh->disconnect;
}

1;
