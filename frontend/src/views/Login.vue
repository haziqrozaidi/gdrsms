<template>
    <div class="container mt-5">
      <div class="row justify-content-center">
        <div class="col-md-6">
          <div class="card">
            <div class="card-header bg-primary text-white">
              <h3 class="text-center">Login</h3>
            </div>
            <div class="card-body">
              <form @submit.prevent="login">
                <div class="mb-3">
                  <label for="username" class="form-label">Username</label>
                  <input 
                    type="text" 
                    class="form-control" 
                    id="username" 
                    v-model="username" 
                    required
                  >
                </div>
                <div class="mb-3">
                  <label for="password" class="form-label">Password</label>
                  <input 
                    type="password" 
                    class="form-control" 
                    id="password" 
                    v-model="password" 
                    required
                  >
                </div>
                <div v-if="errorMessage" class="alert alert-danger">
                  {{ errorMessage }}
                </div>
                <button type="submit" class="btn btn-primary w-100">
                  Login
                </button>
              </form>
            </div>
            <div class="card-footer text-center">
              <router-link to="/register" class="btn btn-link">
                Create an Account
              </router-link>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        username: '',
        password: '',
        errorMessage: ''
      }
    },
    methods: {
      async login() {
        try {
          const response = await axios.post('/api/login', {
            username: this.username,
            password: this.password
          });
  
          // Store token in localStorage
          localStorage.setItem('token', response.data.token);
          
          // Redirect to dashboard or home page
          this.$router.push('/dashboard');
        } catch (error) {
          this.errorMessage = error.response.data.message || 'Login failed';
        }
      }
    }
  }
  </script>
  
  <style scoped>
  .card {
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  }
  </style>
  