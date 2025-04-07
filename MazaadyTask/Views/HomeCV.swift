import SwiftUI

struct CourseView: View {
    var avatars = ["Avatar1","Avatar2","Avatar3","Avatar4"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header
                    HStack {
                        HStack(spacing: 12) {
                            Image("pp")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                Text("Hallo, Samuel!")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text("+1600 Points")
                                        .foregroundColor(.yellow)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Image("notification")
                            .resizable()
                            .frame(width: 16, height: 20, alignment: .center)
                    }
                    .padding(.horizontal)
                    
                    // Profile Images
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(0..<avatars.count) { index in
                                ZStack (alignment: .bottomTrailing){
                                    Image(avatars[index])
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .shadow(radius: 2)
                                        .background(Color.clear.cornerRadius(25).overlay {
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(Color.red.opacity(0.5), lineWidth: 5)
                                        })
                                    
                                    Image("video")
                                        .resizable()
                                        .scaledToFit()
                                        .offset(x: 2, y: 2)
                                        .foregroundColor(.blue)
                                        .frame(width: 24, height: 24)
                                        .background(Circle().fill(Color.cyan).overlay {
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                                .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 0)
                                        })
                                }
                            }
                        }
                        .padding()
                    }
                    
                    // Course Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Upcoming")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("course of this week")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            CategoryButton(title: "All", isSelected: true)
                            CategoryButton(title: "UI/UX", isSelected: false)
                            CategoryButton(title: "Illustration", isSelected: false)
                            CategoryButton(title: "3D Animation", isSelected: false)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Course Card
                    CourseCard()
                        .padding(.horizontal)
                }
                .padding(.vertical, 30)
            }
        }
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(isSelected ? Color.pink : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .white : .gray)
            .cornerRadius(20)
    }
}

struct CourseCard: View {
    var body: some View {
        ZStack {
            Image("course1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 400)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Free e-book!")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.yellow)
                    .cornerRadius(12)
                
                Spacer()
                Text("Step design sprint for beginner")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                HStack {
                    Image("time")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                    Text("5h 21m")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("6 lessons")
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.cyan)
                        .cornerRadius(5)
                    
                    Text("UI/UX")
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .cornerRadius(5)
                    
                    Text("Free")
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.purple)
                        .cornerRadius(5)
                }
                
                HStack {
                    Image("inst")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text("Laurel Seilha")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        Text("Product Designer")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }.padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

struct HomeCV_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CourseView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    }
                }
                .tag(0)
            
            Text("المسارات")
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 1 ? "map.fill" : "map")
                    }
                }
                .tag(1)
            
            Text("الرسائل")
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 2 ? "message.fill" : "message")
                    }
                }
                .tag(2)
            
            Text("الملف الشخصي")
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                    }
                }
                .tag(3)
        }
        .accentColor(.pink)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UITabBar.appearance().standardAppearance = appearance
        }
    }
} 