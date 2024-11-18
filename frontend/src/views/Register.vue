<template>
    <div class="container mt-5">
      <div class="row justify-content-center">
        <div class="col-md-8">
          <div class="card">
            <div class="card-header bg-primary text-white">
              <h3 class="text-center">Create User Account</h3>
            </div>
            <div class="card-body">
              <form @submit.prevent="registerUser">
                <div class="row">
                  <div class="col-md-6 mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input 
                      type="text" 
                      class="form-control" 
                      id="username" 
                      v-model="user.username" 
                      required
                    >
                  </div>
                  <div class="col-md-6 mb-3">
                    <label for="fullName" class="form-label">Full Name</label>
                    <input 
                      type="text" 
                      class="form-control" 
                      id="fullName" 
                      v-model="user.fullName" 
                      required
                    >
                  </div>
                </div>
  
                <div class="mb-3">
                  <label for="email" class="form-label">Email</label>
                  <input 
                    type="email" 
                    class="form-control" 
                    id="email" 
                    v-model="user.email" 
                    required
                  >
                </div>
  
                <div class="row">
                  <div class="col-md-6 mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input 
                      type="password" 
                      class="form-control" 
                      id="password" 
                      v-model="user.password" 
                      required
                    >
                  </div>
                  <div class="col-md-6 mb-3">
                    <label for="confirmPassword" class="form-label">Confirm Password</label>
                    <input 
                      type="password" 
                      class="form-control" 
                      id="confirmPassword" 
                      v-model="user.confirmPassword" 
                      required
                    >
                  </div>
                </div>
  
                <div class="row">
                  <div class="col-md-6 mb-3">
                    <label for="contactNo" class="form-label">Contact Number</label>
                    <input 
                      type="tel" 
                      class="form-control" 
                      id="contactNo" 
                      v-model="user.contactNo"
                    >
                  </div>
                  <div class="col-md-6 mb-3">
                    <label for="faculty" class="form-label">Faculty</label>
                    <select 
                      class="form-select" 
                      id="faculty" 
                      v-model="user.faculty"
                    >
                      <option value="">Select Faculty</option>
                      <option value="Computing">Faculty of Computing</option>
                      <option value="Engineering">Faculty of Engineering</option>
                      <option value="Science">Faculty of Science</option>
                    </select>
                  </div>
                </div>
  
                <div class="mb-3">
                  <label for="userType" class="form-label">User Type</label>
                  <select 
                    class="form-select" 
                    id="userType" 
                    v-model="user.userType" 
                    required
                  >
                    <option value="">Select User Type</option>
                    <option value="student">Student</option>
                    <option value="lecturer">Lecturer</option>
                  </select>
                </div>
  
                <!-- Conditional fields based on user type -->
                <div v-if="user.userType === 'student'" class="mb-3">
                  <label for="matricNo" class="form-label">Matric Number</label>
                  <input 
                    type="text" 
                    class="form-control" 
                    id="matricNo" 
                    v-model="user.matricNo"
                    required
                  >
                </div>
  
                <div v-if="user.userType === 'lecturer'" class="mb-3">
                  <label for="staffNo" class="form-label">Staff Number</label>
                  <input 
                    type="text" 
                    class="form-control" 
                    id="staffNo" 
                    v-model="user.staffNo"
                    required
                  >
                </div>
  
                <div v-if="errorMessage" class="alert alert-danger">
                  {{ errorMessage }}
                </div>
  
                <button type="submit" class="btn btn-primary w-100">
                  Create Account
                </button>
              </form>
            </div>
            <div class="card-footer text-center">
              <router-link to="/login" class="btn btn-link">
                Already have an account? Login
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
        user: {
          username: '',
          fullName: '',
          email: '',
          password: '',
          confirmPassword: '',
          contactNo: '',
          faculty: '',
          userType: '',
          matricNo: '',
          staffNo: ''
        },
        errorMessage: ''
      }
    },
    methods: {
      async registerUser() {
        // Validate password match
        if (this.user.password !== this.user.confirmPassword) {
          this.errorMessage = 'Passwords do not match';
          return;
        }
  
        try {
          // Prepare payload based on user type
          const payload = {
            username: this.user.username,
            full_name: this.user.fullName,
            email: this.user.email,
            password: this.user.password,
            contact_no: this.user.contactNo,
            faculty: this.user.faculty,
            user_type: this.user.userType
          };
  
          // Add additional fields based on user type
          if (this.user.userType === 'student') {
            payload.matric_no = this.user.matricNo;
          } else if (this.user.userType === 'lecturer') {
            payload.staff_no = this.user.staffNo;
          }
  
          // Send registration request
          const response = await axios.post('/api/register', payload);
  
          // Redirect to login or show success message
          this.$router.push('/login');
        } catch (error) {
          this.errorMessage = error.response.data.message || 'Registration failed';
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
  