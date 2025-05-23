import 'package:detectionapp/service/local_notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:detectionapp/screen/subnoti.dart';
import 'dart:convert';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Notipage extends StatefulWidget {
  const Notipage({super.key});
  @override
  DataPageState createState() => DataPageState();
}

class User {
  final dynamic id, status, timestamp;

  User({required this.id, this.status, required this.timestamp});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'], status: json['status'], timestamp: json['timestamp']);
  }
}

class DataPageState extends State<Notipage> {
  List<dynamic> id = [];
  num? iddatas;
  List<dynamic> status = [];
  String? statusapp;
  String? timestampapp;
  List<dynamic> timestamp = [];
  Timer? _timer;
  num? _lastData;

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 5), (_) {
      fetchUsers();
    });
  }

  Future<void> fetchUsers() async {
    try {
      final url = Uri.parse('http://49.0.91.113:3000/api/getDataFlutter/');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = User.fromJson(data);
        setState(() {
          id = user.id;
          iddatas = id.last;
          status = user.status;
          statusapp = status.last;
          timestamp = user.timestamp;
          timestampapp = timestamp.last;
          // _lastData = id.last.toString();
        });
        if (_lastData == null) {
          setState(() {
            id = user.id;
            iddatas = id.last;
            status = user.status;
            statusapp = status.last;
            timestamp = user.timestamp;
            timestampapp = timestamp.last;
            _lastData = id.last;
          });
          return;
        }
        if (int.parse(iddatas.toString()) > int.parse(_lastData.toString())) {
          setState(() {
            id = user.id;
            iddatas = id.last;
            status = user.status;
            statusapp = status.last;
            timestamp = user.timestamp;
            timestampapp = timestamp.last;
            _lastData = id.last;
          });
          await LocalNotificationsService.showInstantNotification(
              statusapp, timestampapp, iddatas.toString());
          print('User id: ${int.parse(iddatas.toString())}');
          print('LastData: ${int.parse(_lastData.toString())}');
          print('มีข้อมูลใหม่');
        } else {
          print('User id: ${int.parse(iddatas.toString())}');
          print('LastData: ${int.parse(_lastData.toString())}');
          print('ไม่มีข้อมูลใหม่');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (err) {
      print('Exception: $err');
    }
  }

  Future<void> _deleteData(num ids) async {
    try {
      final url =
          Uri.parse('http://49.0.91.113:3000/api/deletedataflutter/${ids}');
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        print('Delete: ${ids}');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (err) {
      print('Exception: $err');
    }
  }

  void _showDialogs(String? status, String? timestamp, num id) {
    try {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Alert!',
            style: TextStyle(fontFamily: 'Roboto'),
          ),
          content: Text('Do you want to delete: $status $timestamp ?',
              style: TextStyle(fontFamily: 'Roboto')),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(fontFamily: 'Roboto')),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                await _deleteData(id);
                await fetchUsers();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } catch (err) {
      print('Exception: $err');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchUsers();
      _startPolling();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  //DataList
  final List<Map<String, String>> notifications = [
    {
      'title': 'คำสั่งซื้อใหม่',
      'subtitle': 'Human-Detection',
      'time': '5 นาทีที่แล้ว',
      'icon': 'human-detect',
    },
    {
      'title': 'อัปเดตระบบ',
      'subtitle': 'Power-On',
      'time': '1 ชั่วโมงที่แล้ว',
      'icon': 'power-on',
    },
    {
      'title': 'ข้อความใหม่',
      'subtitle': 'Power-Off',
      'time': 'เมื่อวานนี้',
      'icon': 'power-off',
    },
    {
      'title': 'ข้อความใหม่',
      'subtitle': 'Power-Off',
      'time': 'เมื่อวานนี้',
      'icon': 'power-off',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    // title: const Text("Linking Up Your Success.",
                    //     style: TextStyle(
                    //         color: Color.fromARGB(255, 17, 0, 255),
                    //         fontSize: 16.0,
                    //         fontWeight: FontWeight.bold)),
                    background: Image.asset(
                      "assets/images/cam2.png",
                      fit: BoxFit.cover,
                    )),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  const TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Color.fromARGB(255, 204, 48, 0),
                    indicatorColor: Color.fromARGB(255, 196, 46, 0),
                    unselectedLabelColor: Colors.grey,
                    tabs: _tabs,
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: Container(
              color: Colors.indigo.shade50,
              child: TabBarView(
                children: [
                  // Tab 1: Notification List
                  ListView.builder(
                    itemCount: status.length,
                    padding: EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      final statuss = status[index];
                      final timestamps = timestamp[index];
                      final ids = id[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Slidable(
                              key: ValueKey(id[index]),
                              endActionPane: ActionPane(
                                motion: ScrollMotion(),
                                dismissible: DismissiblePane(
                                  onDismissed: () async {
                                    await _deleteData(ids);
                                    await fetchUsers();
                                  },
                                ),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                      _showDialogs(statuss, timestamps, ids);
                                    },
                                    backgroundColor: Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              // endActionPane: ActionPane(
                              //   motion: ScrollMotion(),
                              //   children: [
                              //     SlidableAction(
                              //       onPressed: (context) {},
                              //       backgroundColor: Color(0xFF7BC043),
                              //       foregroundColor: Colors.white,
                              //       icon: Icons.archive,
                              //       label: 'Archive',
                              //     ),
                              //   ],
                              // ),
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: DismissibleFadeItem(
                                  id: id[index],
                                  statuss: status[index],
                                  timestamp: timestamp[index],
                                  onDelete: (int deleteId) async {
                                    await _deleteData(deleteId);
                                    await fetchUsers();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Tab 2: Cart
                  // ListView.builder(
                  //   itemCount: 10,
                  //   itemBuilder: (context, index) => ListTile(
                  //     leading: const Icon(Icons.shopping_cart),
                  //     title: Text("Cart Item #$index"),
                  //   ),
                  // ),

                  // Tab 3: Profile
                  const CompanyProfilePage()
                ],
              )),
        ),
      ),
    );
  }
}

const _tabs = [
  Tab(icon: Icon(Icons.notification_add_rounded), text: "Notification"),
  // Tab(icon: Icon(Icons.shopping_bag_rounded), text: "Cart"),
  Tab(icon: Icon(Icons.person), text: "Company Profile"),
];

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class NotiCard extends StatelessWidget {
  const NotiCard({
    super.key,
    required this.name,
    required this.time,
    required this.image,
    required this.press,
  });

  final String name, time;
  final VoidCallback press;
  final AssetImage image;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 24.0 / 2,
        ),
        onTap: press,
        leading: CircleAvatarWithActiveIndicator(
          image: image,
          radius: 28,
        ),
        title: Text(name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            Text(
              time,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ));
  }
}

class CircleAvatarWithActiveIndicator extends StatelessWidget {
  const CircleAvatarWithActiveIndicator({
    super.key,
    this.image,
    this.radius = 24,
  });

  final AssetImage? image;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundImage: image,
          backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        )
      ],
    );
  }
}

class ProfileInfoItem {
  final String title;
  final String value;
  const ProfileInfoItem(this.title, this.value);
}

final Uri _url = Uri.parse('https://www.networklink.co.th/');
Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

class CompanyProfilePage extends StatelessWidget {
  const CompanyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Company Banner
              Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/profile-bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(20),
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.5),
                  child: const Text(
                    'NetWorklink.Co.Ltd,',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Company Info Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'About Us',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'We provide design and development services for both hardware and software innovations, including software applications, web applications, mobile applications, database structure design, and APIs. Our integrated systems also work with various hardware devices such as Smart Lighting, Smart Electric Measurement, Intelligent Transportation Systems, and Intelligent Work Zones, among others.',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.location_on),
                          title: const Text('Head Office'),
                          subtitle: const Text(
                              'No. 191 Photharam Muangmai, Moo 4, Ban Luek Subdistrict, Photharam District, Ratchaburi Province, 70120'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.phone),
                          title: const Text('Phone'),
                          subtitle: const Text('098-7516506'),
                        ),
                        ListTile(
                          leading: const FaIcon(FontAwesomeIcons.line),
                          title: const Text('Line ID'),
                          subtitle: const Text('@networklink'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: const Text('Email'),
                          subtitle: const Text('info@networklink.co.th'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Services Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Our Services',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        ServiceChip(label: 'Mobile Development'),
                        ServiceChip(label: 'Web Development'),
                        ServiceChip(label: 'UI/UX Design'),
                        ServiceChip(label: 'Cloud Solutions'),
                        ServiceChip(label: 'Consulting'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Contact Button
              ElevatedButton.icon(
                onPressed: _launchUrl,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.message, color: Colors.white),
                label: const Text(
                  'Contact Us',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceChip extends StatelessWidget {
  final String label;

  const ServiceChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.indigo.shade50,
      labelStyle: const TextStyle(color: Colors.blue),
    );
  }
}

class DismissibleFadeItem extends StatefulWidget {
  final int id;
  final String statuss;
  final String timestamp;
  final Future<void> Function(int id) onDelete;

  const DismissibleFadeItem({
    super.key,
    required this.id,
    required this.statuss,
    required this.timestamp,
    required this.onDelete,
  });

  @override
  State<DismissibleFadeItem> createState() => _DismissibleFadeItemState();
}

class _DismissibleFadeItemState extends State<DismissibleFadeItem> {
  bool _isVisible = true;

  //IconDataList
  IconData getIcon(String? iconName) {
    switch (iconName) {
      case 'human-detect':
        return Icons.directions_run_rounded;
      case 'PowerOn':
        return Icons.power_rounded;
      case 'PowerOff':
        return Icons.power_off_rounded;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return SizedBox.shrink();

    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: _isVisible ? 1.0 : 0.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) {
                return SubnotiPage(
                    id: widget.id,
                    status: widget.statuss,
                    timestamp: widget.timestamp);
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final slide = Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation);
                final fade = Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(animation);
                return SlideTransition(
                  position: slide,
                  child: FadeTransition(
                    opacity: fade,
                    child: child,
                  ),
                );
              },
            ),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigo.shade100,
            child: Icon(getIcon(widget.statuss), color: Colors.indigo),
          ),
          title: Text(
            widget.statuss,
            style: TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            widget.timestamp,
            style: TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // trailing: Icon(Icons.menu),
        ),
      ),
    );
    //     ),
    //   ),
    // );
  }
}
