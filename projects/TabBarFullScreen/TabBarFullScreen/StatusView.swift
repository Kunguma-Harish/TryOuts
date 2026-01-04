//
//  StatusView.swift
//  TabBarFullScreen
//
//  Created by AI Assistant
//

import SwiftUI

struct StatusView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddStatus = false
    @State private var newStatusText = ""
    @State private var selectedStatus: Status?
    
    var body: some View {
        NavigationView {
            List {
                // My Status Section
                MyStatusRowView {
                    showingAddStatus = true
                }
                
                // Other Statuses
                ForEach(dataManager.statuses) { status in
                    StatusRowView(status: status)
                        .onTapGesture {
                            selectedStatus = status
                        }
                }
            }
            .navigationTitle("Status")
            .listStyle(PlainListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddStatus = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddStatus) {
            AddStatusView(newStatusText: $newStatusText) {
                addNewStatus()
            }
        }
        .sheet(item: $selectedStatus) { status in
            StatusDetailView(status: status)
        }
    }
    
    private func addNewStatus() {
        guard !newStatusText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newStatus = Status(
            userName: "You",
            timestamp: Date(),
            content: newStatusText,
            profileImage: "person.circle.fill",
            viewCount: 0
        )
        
        dataManager.statuses.insert(newStatus, at: 0)
        newStatusText = ""
        showingAddStatus = false
    }
}

struct MyStatusRowView: View {
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Profile Image
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 25))
                    .foregroundColor(.gray)
                    .frame(width: 50, height: 50)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("My Status")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("Tap to add status update")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatusRowView: View {
    let status: Status
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile Image with Status Ring
            ZStack {
                Circle()
                    .stroke(isRecentStatus ? Color.green : Color.clear, lineWidth: 3)
                    .frame(width: 54, height: 54)
                
                Image(systemName: status.profileImage)
                    .font(.system(size: 25))
                    .foregroundColor(.gray)
                    .frame(width: 50, height: 50)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(status.userName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(formatTimestamp(status.timestamp))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text(status.content)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Text("\(status.viewCount) views")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private var isRecentStatus: Bool {
        Date().timeIntervalSince(status.timestamp) < 24 * 60 * 60
    }
    
    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateFormat = "MM/dd"
        }
        
        return formatter.string(from: date)
    }
}

struct AddStatusView: View {
    @Binding var newStatusText: String
    let onSave: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("What's on your mind?")
                    .font(.title2)
                    .padding(.top)
                
                TextEditor(text: $newStatusText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .frame(minHeight: 120)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Status")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        onSave()
                    }
                    .disabled(newStatusText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

struct StatusDetailView: View {
    let status: Status
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Profile Section
                VStack(spacing: 12) {
                    Image(systemName: status.profileImage)
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                        .frame(width: 100, height: 100)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                    
                    Text(status.userName)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .padding(.top, 20)
                
                // Status Content
                ScrollView {
                    Text(status.content)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                // Status Info
                VStack(spacing: 8) {
                    HStack {
                        Text("Posted:")
                        Spacer()
                        Text(formatFullTimestamp(status.timestamp))
                    }
                    
                    HStack {
                        Text("Views:")
                        Spacer()
                        Text("\(status.viewCount)")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Status")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func formatFullTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

extension Status: Identifiable {}

#Preview {
    StatusView()
        .environmentObject(DataManager.shared)
}

