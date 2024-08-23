import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'SMKN 4 Bogor',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {
                print('Pemberitahuan tapped');
              },
            ),
            IconButton(
              icon: const Icon(Icons.message_outlined, color: Colors.white),
              onPressed: () {
                print('Pesan tapped');
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.white),
              onPressed: () {
                print('Pengaturan tapped');
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            BerandaTab(),
            UsersTab(),
            ProfilTab(),
          ],
        ),
        bottomNavigationBar: Container(
          height: 80.0, // Adjust the height of the bottom navigation bar
          decoration: BoxDecoration(
            color: Colors.white, // Background color
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60.0), // Rounded top-left corner
              topRight: Radius.circular(60.0), // Rounded top-right corner
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, -2), // Shadow offset
              ),
            ],
          ),
          child: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.dashboard_outlined), text: 'Dashboard'),
              Tab(icon: Icon(Icons.group_outlined), text: 'Siswa'),
              Tab(icon: Icon(Icons.account_circle_outlined), text: 'Profil'),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Color.fromARGB(255, 176, 176, 176),
            indicatorColor: Colors.blue,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 0.0), // Remove horizontal padding for indicator
            labelPadding: EdgeInsets.symmetric(horizontal: 0.0), // Remove horizontal padding for labels
            padding: EdgeInsets.zero, // Remove default padding
          ),
        ),
      ),
    );
  }
}


class BerandaTab extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.school_outlined, 'label': 'Data Sekolah', 'color': Colors.blueAccent},
    {'icon': Icons.book_outlined, 'label': 'Pelajaran', 'color': Colors.orangeAccent},
    {'icon': Icons.calendar_today_outlined, 'label': 'Kalender Akademik', 'color': Colors.greenAccent},
    {'icon': Icons.event_note_outlined, 'label': 'Kegiatan', 'color': Colors.pinkAccent},
    {'icon': Icons.assignment_outlined, 'label': 'Penugasan', 'color': Colors.redAccent},
    {'icon': Icons.map_outlined, 'label': 'Lokasi Kampus', 'color': Colors.purpleAccent},
    {'icon': Icons.contact_phone_outlined, 'label': 'Kontak Guru', 'color': Colors.tealAccent},
    {'icon': Icons.info_outline, 'label': 'Pengumuman', 'color': Colors.amberAccent},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const SizedBox(height: 10.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Text(
              'Selamat Datang di SMK Negeri 4!',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return GestureDetector(
                  onTap: () {
                    print('${item['label']} tapped');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12.0), // Adjust padding as needed
                        decoration: BoxDecoration(
                          color: item['color'], // Varied background colors for each icon
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Icon(
                          item['icon'],
                          size: 40.0,
                          color: Colors.white, // Icon color
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        item['label'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12.0, color: Colors.black),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UsersTab extends StatefulWidget {
  @override
  _UsersTabState createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
    final List<Color> _iconColors = [
    Colors.blueAccent,
    Colors.orangeAccent,
    Colors.greenAccent,
    Colors.redAccent,
    Colors.purpleAccent,
    Colors.pinkAccent,
    Colors.tealAccent,
    Colors.amberAccent,
  ];
 Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  List<User> _filteredUsers = [];
  List<User> _allUsers = [];

  void _filterUsers(String query) {
    final filtered = _allUsers.where((user) {
      final nameLower = user.firstName.toLowerCase();
      final emailLower = user.email.toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower) || emailLower.contains(searchLower);
    }).toList();

    setState(() {
      _filteredUsers = filtered;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers().then((users) {
      setState(() {
        _allUsers = users;
        _filteredUsers = users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Siswa',
          style: TextStyle(
            color: Colors.black, // black color for the title
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // Shadow container with rounded corners
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the container
                borderRadius: BorderRadius.circular(30.0), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(2, 2), // Shadow direction
                  ),
                ],
              ),
              child: TextField(
                onChanged: _filterUsers,
                decoration: InputDecoration(
                  hintText: 'Cari siswa...',
                  suffixIcon: Icon(Icons.search), // Search icon on the right
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Adjust padding
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0), // Fully rounded corners
                    borderSide: BorderSide.none, // No border by default
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0), // Fully rounded corners
                    borderSide: BorderSide(color: Colors.grey, width: 1.0), // Outline border color when not focused
                  ),
                  filled: true,
                  fillColor: Colors.transparent, // Transparent fill color to show rounded shadow
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? const Center(child: Text('No users found.'))
                : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.avatar),
                            radius: 25,
                          ),
                          title: Text(user.firstName),
                          subtitle: Text(user.email),
                          trailing: Icon(Icons.arrow_forward_ios_outlined),
                          onTap: () {
                            print('User tapped: ${user.firstName}');
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ProfilTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row to place the profile picture on the left and text beside it
          Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/6671-sukuna.png'), // Replace with your image path
              ),
              SizedBox(width: 20), // Space between the image and text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Akbar TR',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4), // Space between name and email
                  Text(
                    'akbartolieb@gmail.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30), // Space below the profile section
          Text(
            'Biodata',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8), // Space between biodata heading and list items
          ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Nama Lengkap',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Akbar Tolib Ramadan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.pinkAccent,
              child: Icon(
                Icons.cake,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Tanggal Lahir',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              '30 Juni 2007',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.orangeAccent,
              child: Icon(
                Icons.school,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Sekolah',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'SMK Negeri 4 Bogor',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.greenAccent,
              child: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Alamat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Jl. YTTA No. 123, Bogor',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class User {
  final String firstName;
  final String email;
  final String avatar;

  User({required this.firstName, required this.email, required this.avatar});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }
}
