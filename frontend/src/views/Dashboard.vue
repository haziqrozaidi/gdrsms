<template>
    <div class="dashboard container-fluid">
      <div class="row">
        <!-- Sidebar -->
        <div class="col-md-2 bg-light sidebar">
          <div class="profile-section text-center p-3">
            <img :src="userProfile.avatar" class="rounded-circle mb-2" width="100" height="100">
            <h5>{{ userProfile.name }}</h5>
            <p class="text-muted">{{ userProfile.role }}</p>
          </div>
          
          <div class="list-group">
            <a 
              href="#" 
              class="list-group-item list-group-item-action"
              :class="{ active: activeSection === 'drive' }"
              @click="activeSection = 'drive'"
            >
              <i class="fab fa-google-drive me-2"></i> Google Drive
            </a>
            <a 
              href="#" 
              class="list-group-item list-group-item-action"
              :class="{ active: activeSection === 'shared' }"
              @click="activeSection = 'shared'"
            >
              <i class="fas fa-share-alt me-2"></i> Shared Resources
            </a>
            <a 
              href="#" 
              class="list-group-item list-group-item-action"
              :class="{ active: activeSection === 'courses' }"
              @click="activeSection = 'courses'"
            >
              <i class="fas fa-book me-2"></i> Course Resources
            </a>
            <a 
              href="#" 
              class="list-group-item list-group-item-action"
              :class="{ active: activeSection === 'analytics' }"
              @click="activeSection = 'analytics'"
            >
              <i class="fas fa-chart-pie me-2"></i> Analytics
            </a>
          </div>
        </div>
  
        <!-- Main Content -->
        <div class="col-md-10 ms-sm-auto px-4">
          <!-- Google Drive Section -->
          <div v-if="activeSection === 'drive'" class="drive-section">
            <h1 class="mt-4">Google Drive</h1>
            
            <div class="row">
              <div class="col-12">
                <div class="card">
                  <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">My Drive</h5>
                    <div>
                      <button class="btn btn-primary me-2">
                        <i class="fas fa-upload me-1"></i> Upload
                      </button>
                      <button class="btn btn-success">
                        <i class="fas fa-folder-plus me-1"></i> New Folder
                      </button>
                    </div>
                  </div>
                  <div class="card-body">
                    <table class="table table-hover">
                      <thead>
                        <tr>
                          <th>Name</th>
                          <th>Owner</th>
                          <th>Last Modified</th>
                          <th>Size</th>
                          <th>Actions</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr v-for="file in driveFiles" :key="file.id">
                          <td>
                            <i :class="getFileIcon(file.type)" class="me-2"></i>
                            {{ file.name }}
                          </td>
                          <td>{{ file.owner }}</td>
                          <td>{{ file.lastModified }}</td>
                          <td>{{ file.size }}</td>
                          <td>
                            <div class="btn-group">
                              <button class="btn btn-sm btn-info">
                                <i class="fas fa-eye"></i>
                              </button>
                              <button class="btn btn-sm btn-success">
                                <i class="fas fa-share-alt"></i>
                              </button>
                              <button class="btn btn-sm btn-danger">
                                <i class="fas fa-trash"></i>
                              </button>
                            </div>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
          </div>
  
          <!-- Shared Resources Section -->
          <div v-if="activeSection === 'shared'" class="shared-section">
            <h1 class="mt-4">Shared Resources</h1>
            <div class="row">
              <div class="col-12">
                <div class="card">
                  <div class="card-header">
                    Resources Shared with Me
                  </div>
                  <div class="card-body">
                    <table class="table table-striped">
                      <thead>
                        <tr>
                          <th>Resource Name</th>
                          <th>Shared By</th>
                          <th>Date Shared</th>
                          <th>Course</th>
                          <th>Actions</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr v-for="resource in sharedResources" :key="resource.id">
                          <td>
                            <i :class="getFileIcon(resource.type)" class="me-2"></i>
                            {{ resource.name }}
                          </td>
                          <td>{{ resource.sharedBy }}</td>
                          <td>{{ resource.dateShared }}</td>
                          <td>{{ resource.course }}</td>
                          <td>
                            <button class="btn btn-sm btn-primary me-1">
                              <i class="fas fa-download"></i>
                            </button>
                            <button class="btn btn-sm btn-info">
                              <i class="fas fa-eye"></i>
                            </button>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
          </div>
  
          <!-- Courses Resources Section -->
          <div v-if="activeSection === 'courses'" class="courses-section">
            <h1 class="mt-4">Course Resources</h1>
            <div class="row">
              <div class="col-md-4" v-for="course in courses" :key="course.code">
                <div class="card mb-4">
                  <div class="card-header">{{ course.name }}</div>
                  <div class="card-body">
                    <h5 class="card-title">{{ course.code }}</h5>
                    <p class="card-text">{{ course.lecturer }}</p>
                    <div class="d-flex justify-content-between">
                      <span class="badge bg-primary">{{ course.resourceCount }} Resources</span>
                      <button class="btn btn-sm btn-outline-primary">View Resources</button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
  
          <!-- Analytics Section -->
          <div v-if="activeSection === 'analytics'" class="analytics-section">
            <h1 class="mt-4">Resource Analytics</h1>
            <div class="row">
              <div class="col-md-4">
                <div class="card bg-primary text-white mb-3">
                  <div class="card-body">
                    <h5 class="card-title">Total Resources</h5>
                    <p class="display-4">{{ analytics.totalResources }}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="card bg-success text-white mb-3">
                  <div class="card-body">
                    <h5 class="card-title">Shared Resources</h5>
                    <p class="display-4">{{ analytics.sharedResources }}</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="card bg-warning text-white mb-3">
                  <div class="card-body">
                    <h5 class="card-title">Resource Types</h5>
                    <ul class="list-unstyled">
                      <li>Docs: {{ analytics.resourceTypes.docs }}</li>
                      <li>Sheets: {{ analytics.resourceTypes.sheets }}</li>
                      <li>Presentations: {{ analytics.resourceTypes.presentations }}</li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        activeSection: 'drive',
        userProfile: {
          name: 'John Doe',
          role: 'Student',
          avatar: 'https://via.placeholder.com/150'
        },
        driveFiles: [
          {
            id: 1,
            name: 'Project Proposal.docx',
            type: 'docx',
            owner: 'John Doe',
            lastModified: '2023-12-10',
            size: '256 KB'
          },
          {
            id: 2,
            name: 'Research Data.xlsx',
            type: 'xlsx',
            owner: 'John Doe',
            lastModified: '2023-12-05',
            size: '1.2 MB'
          }
        ],
        sharedResources: [
          {
            id: 1,
            name: 'Lecture Notes.pdf',
            type: 'pdf',
            sharedBy: 'Dr. Smith',
            dateShared: '2023-12-08',
            course: 'Web Programming'
          }
        ],
        courses: [
          {
            code: 'CSCI101',
            name: 'Introduction to Programming',
            lecturer: 'Dr. John Doe',
            resourceCount: 15
          },
          {
            code: 'CSCI202',
            name: 'Database Systems',
            lecturer: 'Prof. Jane Smith',
            resourceCount: 20
          }
        ],
        analytics: {
          totalResources: 45,
          sharedResources: 25,
          resourceTypes: {
            docs: 15,
            sheets: 10,
            presentations: 5
          }
        }
      }
    },
    methods: {
      getFileIcon(fileType) {
        const iconMap = {
          'docx': 'fas fa-file-word text-primary',
          'xlsx': 'fas fa-file-excel text-success',
          'pdf': 'fas fa-file-pdf text-danger',
          'pptx': 'fas fa-file-powerpoint text-warning'
        };
        return iconMap[fileType] || 'fas fa-file';
      }
    }
  }
  </script>
  
  <style scoped>
  .sidebar {
    height: 100vh;
    position: fixed;
    top: 0;
    left: 0;
    z-index: 100;
    box-shadow: inset -1px 0 0 rgba(0, 0, 0, .1);
  }
  
  .list-group-item.active {
    background-color: #007bff;
    border-color: #007bff;
  }
  
  .profile-section img {
    object-fit: cover;
  }
  
  @media (max-width: 768px) {
    .sidebar {
      display: none;
    }
  }
  </style>
  