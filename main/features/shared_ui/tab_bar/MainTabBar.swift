//
//  MainTabBar.swift
//  ReadyMadeProjectSetup
//
//  Created by ibarts on 05/10/26.
//

import SwiftUI

// MARK: - App Tab Enum
enum AppTab: String, CaseIterable, Identifiable {
    case home
    case attendance
    case approvals
    case students
    case internships
    case profile
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .attendance:
            return "Attendance"
        case .approvals:
            return "Approvals"
        case .students:
            return "Students"
        case .internships:
            return "Internships"
        case .profile:
            return "Profile"
        }
    }
    
    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .attendance:
            return "calendar.badge.clock"
        case .approvals:
            return "checkmark.circle"
        case .students:
            return "person.2"
        case .internships:
            return "briefcase"
        case .profile:
            return "person"
        }
    }
}

// MARK: - Dynamic Main Tab Bar View (iOS 18+ Tab API with Role Conditions)
struct MainTabBarView: View {
    // MARK: - Properties
    let user: User
    let onLogout: () -> Void
    
    @State private var selectedTab: AppTab = .home
    
    // MARK: - Initialization
    init(user: User, onLogout: @escaping () -> Void) {
        self.user = user
        self.onLogout = onLogout
    }
    
    // MARK: - Body
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab (Visible for all roles)
            Tab(AppTab.home.title, systemImage: AppTab.home.iconName, value: AppTab.home) {
                HomeScreenView(currentUser: user)
            }
            
            // Attendance Tab (Visible for Student)
            if user.role == .student {
                Tab(AppTab.attendance.title, systemImage: AppTab.attendance.iconName, value: AppTab.attendance) {
                    AttendanceView()
                }
            }
            
            // Approvals Tab (Visible for Organisation & College)
            if user.role == .organisation || user.role == .college {
                Tab(AppTab.approvals.title, systemImage: AppTab.approvals.iconName, value: AppTab.approvals) {
                    ApprovalsView()
                }
            }
            
            // Students Tab (Visible for Mentor, Organisation & College)
            if user.role == .mentor || user.role == .organisation || user.role == .college {
                Tab(AppTab.students.title, systemImage: AppTab.students.iconName, value: AppTab.students) {
                    StudentsView(role: user.role)
                }
            }
            
            // Internships Tab (Visible for Student)
            if user.role == .student {
                Tab(AppTab.internships.title, systemImage: AppTab.internships.iconName, value: AppTab.internships) {
                    InternshipsView()
                }
            }
            
            // Profile Tab (Visible for all roles)
            Tab(AppTab.profile.title, systemImage: AppTab.profile.iconName, value: AppTab.profile) {
                ProfileView(user: user, onLogout: onLogout)
            }
        }
        .tint(.orange)
    }
}

// MARK: - Tab Feature Screens

// MARK: Attendance Screen (Student)
struct AttendanceView: View {
    @State private var isCheckedIn: Bool = false
    
    private let attendanceHistory = [
        ("Monday, Oct 5", "09:05 AM", "Present", Color.green),
        ("Friday, Oct 2", "09:12 AM", "Present", Color.green),
        ("Thursday, Oct 1", "09:40 AM", "Late", Color.orange),
        ("Wednesday, Sep 30", "-", "Excused", Color.blue),
        ("Tuesday, Sep 29", "09:02 AM", "Present", Color.green)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Summary Card
                    VStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Overall Attendance")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("94%")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.green)
                            }
                            Spacer()
                            ZStack {
                                Circle()
                                    .stroke(Color.green.opacity(0.2), lineWidth: 8)
                                    .frame(width: 60, height: 60)
                                Circle()
                                    .trim(from: 0, to: 0.94)
                                    .stroke(Color.green, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                    .frame(width: 60, height: 60)
                                    .rotationEffect(.degrees(-90))
                            }
                        }
                        
                        Divider()
                        
                        HStack {
                            statItem(label: "Present", value: "34 Days", color: .green)
                            Spacer()
                            statItem(label: "Late", value: "2 Days", color: .orange)
                            Spacer()
                            statItem(label: "Absent", value: "1 Day", color: .red)
                        }
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(14)
                    
                    // Check-in Action
                    Button(action: {
                        withAnimation {
                            isCheckedIn.toggle()
                        }
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: isCheckedIn ? "checkmark.circle.fill" : "hand.tap.fill")
                                .font(.headline)
                            Text(isCheckedIn ? "Checked In Today (09:15 AM)" : "Mark Attendance for Today")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(isCheckedIn ? Color.green : Color.blue)
                        .cornerRadius(12)
                    }
                    
                    // Recent Attendance Logs
                    VStack(alignment: .leading, spacing: 12) {
                        Text("RECENT RECORDS")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 10) {
                            ForEach(attendanceHistory, id: \.0) { item in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(item.0)
                                            .font(.subheadline.weight(.medium))
                                        Text("Time: \(item.1)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(item.2)
                                        .font(.caption.weight(.semibold))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(item.3.opacity(0.15))
                                        .foregroundColor(item.3)
                                        .cornerRadius(8)
                                }
                                .padding(14)
                                .background(Color(.secondarySystemGroupedBackground))
                                .cornerRadius(12)
                            }
                        }
                    }
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Attendance")
        }
    }
    
    private func statItem(label: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(value)
                .font(.footnote.weight(.semibold))
                .foregroundColor(color)
        }
    }
}

// MARK: Approvals Screen
struct ApprovalsView: View {
    @State private var items = [
        "Student Internship Application - Alex Rivera",
        "College MoU Verification - Tech University",
        "Project Submission Review - Sarah Connor",
        "Mentor Enrollment Request - David Miller"
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Pending Approvals (\(items.count))")) {
                    ForEach(items, id: \.self) { item in
                        HStack(spacing: 12) {
                            Image(systemName: "clock.badge.checkmark")
                                .foregroundColor(.orange)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item)
                                    .font(.subheadline.weight(.medium))
                                Text("Awaiting administrative action")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Approvals")
        }
    }
}

// MARK: Students Screen
struct StudentsView: View {
    let role: UserRole
    
    @State private var students = [
        ("Aarav Sharma", "Computer Science", "Year 3"),
        ("Ananya Patel", "Data Engineering", "Year 4"),
        ("Rohan Verma", "AI & Robotics", "Year 2"),
        ("Sneha Kulkarni", "Cybersecurity", "Year 3")
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Enrolled Students (\(role.title) View)")) {
                    ForEach(students, id: \.0) { student in
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.12))
                                    .frame(width: 40, height: 40)
                                Text(student.0.prefix(1))
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(student.0)
                                    .font(.subheadline.weight(.semibold))
                                Text("\(student.1) • \(student.2)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Students")
        }
    }
}

// MARK: Internships Screen
struct InternshipsView: View {
    @State private var opportunities = [
        ("iOS Software Engineer Intern", "Apple Inc.", "Remote / Cupertino"),
        ("Backend Systems Intern", "Google Cloud", "Bangalore / Hybrid"),
        ("Machine Learning Research Intern", "Meta AI", "London / Onsite")
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Featured Internships")) {
                    ForEach(opportunities, id: \.0) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.0)
                                .font(.subheadline.weight(.semibold))
                            HStack {
                                Text(item.1)
                                    .font(.caption.weight(.medium))
                                    .foregroundColor(.blue)
                                Text("•")
                                    .foregroundColor(.secondary)
                                Text(item.2)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Internships")
        }
    }
}

// MARK: Profile Screen
struct ProfileView: View {
    let user: User
    let onLogout: () -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 12) {
                        Image(systemName: user.role.iconName)
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                            .padding(.top, 16)
                        
                        Text(user.name)
                            .font(.title3.weight(.bold))
                        
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Active Role: \(user.role.title)")
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(Color.blue.opacity(0.12))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(16)
                    
                    VStack(spacing: 0) {
                        profileRow(icon: "shield.lefthalf.filled", title: "Security Settings")
                        Divider().padding(.leading, 48)
                        profileRow(icon: "bell.badge", title: "Notification Preferences")
                        Divider().padding(.leading, 48)
                        profileRow(icon: "questionmark.circle", title: "Help & Documentation")
                    }
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(16)
                    
                    // Logout Button
                    Button(action: onLogout) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Log Out")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.top, 10)
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Profile")
        }
    }
    
    private func profileRow(icon: String, title: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.blue)
                .frame(width: 24)
            Text(title)
                .font(.subheadline)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
