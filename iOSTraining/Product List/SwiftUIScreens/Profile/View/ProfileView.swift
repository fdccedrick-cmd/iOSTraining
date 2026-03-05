//
//  ProfileView.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/2/26.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel = ProfileViewModel.shared
    @State private var showLogoutAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                settingsButton
                avatarSection
                statsSection
                accountSettingsSection
                logoutButton
                versionLabel
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .navigationBarHidden(true)
        .alert("Log Out", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Log Out", role: .destructive) {
                viewModel.logout()
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
    }

    // MARK: - Settings Button
    private var settingsButton: some View {
        HStack {
            Spacer()
            Button {
                // TODO: open settings
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 20, weight: .light))
                    .foregroundColor(.primary)
                    .padding(10)
                    .background(Color(.systemBackground))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
            }
        }
        .padding(.top, 16)
    }

    // MARK: - Avatar Section
    private var avatarSection: some View {
        VStack(spacing: 12) {
            // Avatar
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 100, height: 100)

                    Image(systemName: "person.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.secondary)
                }

                // Camera button
                Button {
                    // TODO: pick photo
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 32, height: 32)

                        Image(systemName: "camera.fill")
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                    }
                }
                .offset(x: 4, y: 4)
            }
            .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 4)

            // Email as primary
            Text(viewModel.email)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)

            // Email domain as secondary
            Text(viewModel.emailPrefix)
                .font(.system(size: 14))
                .foregroundColor(.secondary)

            // Member Badge
            HStack(spacing: 6) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)

                Text("ARTISAN CLUB MEMBER")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(1.5)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
            .clipShape(Capsule())
        }
    }

    // MARK: - Stats Section
    private var statsSection: some View {
        HStack(spacing: 16) {
            statCard(
                icon: "bag",
                title: "My Orders",
                subtitle: "\(viewModel.orderCount) ITEMS"
            )
            statCard(
                icon: "heart",
                title: "Favorites",
                subtitle: "\(viewModel.favoritesCount) SAVED"
            )
        }
    }

    private func statCard(icon: String, title: String, subtitle: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 26, weight: .light))
                .foregroundColor(.primary)

            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .tracking(1)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: - Account Settings
    private var accountSettingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ACCOUNT SETTINGS")
                .font(.system(size: 11, weight: .medium))
                .tracking(2)
                .foregroundColor(.secondary)
                .padding(.leading, 4)

            VStack(spacing: 0) {
                ForEach(viewModel.settings) { setting in
                    settingRow(setting: setting)

                    if setting.id != viewModel.settings.last?.id {
                        Divider()
                            .padding(.leading, 56)
                    }
                }
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
    }

    private func settingRow(setting: ProfileSetting) -> some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
                    .frame(width: 36, height: 36)

                Image(systemName: setting.icon)
                    .font(.system(size: 15))
                    .foregroundColor(.primary)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(setting.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)

                Text(setting.subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
        .onTapGesture {
            // TODO: handle row tap
        }
    }

    // MARK: - Logout Button
    private var logoutButton: some View {
        Button {
            showLogoutAlert = true
        } label: {
            Text("Log Out")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color.red.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    // MARK: - Version
    private var versionLabel: some View {
        Text("Version 1.0.0")
            .font(.system(size: 12))
            .foregroundStyle(.tertiary)
    }
}

#Preview {
    ProfileView()
}

