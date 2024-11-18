sub startup {
    my $self = shift;

    # Add routes
    my $r = $self->routes;
    
    # Public routes
    $r->post('/api/login')->to('auth#login');
    $r->post('/api/register')->to('auth#register');
    
}
