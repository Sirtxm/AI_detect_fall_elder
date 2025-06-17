import 'package:flutter/material.dart';

void main() {
  runApp(const FallApp());
}

class FallApp extends StatelessWidget {
  const FallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yuu Care',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const CareListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CareListPage extends StatelessWidget {
  const CareListPage({super.key});
final List<Map<String, dynamic>> people = const [
  {
    "name": "Grandma Somjai",
    "id": "001",
    "image":
        "https://images.pexels.com/photos/12644996/pexels-photo-12644996.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=300"
  },
  {
    "name": "Grandpa Wong",
    "id": "002",
    "image":
        "https://images.pexels.com/photos/19913036/pexels-photo-19913036.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=300"
  },
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F9),
      appBar: AppBar(
        title: const Text("Yuu Care"),
        centerTitle: true,
        backgroundColor: const Color(0xFFE0F2F1),
        foregroundColor: Colors.teal.shade800,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tap on a person to view their current status",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: people.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final person = people[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FallStatusPage(
                            name: person["name"],
                            id: person["id"],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(person["image"]),
                          backgroundColor: Colors.teal.shade50,
                        ),
                        title: Text(
                          person["name"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text("Tap to check latest status"),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FallStatusPage extends StatefulWidget {
  final String name;
  final String id;

  const FallStatusPage({super.key, required this.name, required this.id});

  @override
  State<FallStatusPage> createState() => _FallStatusPageState();
}

class _FallStatusPageState extends State<FallStatusPage> {
  bool isLoading = true;
  bool fallDetected = false;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    fetchStatus();
  }

  Future<void> fetchStatus() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    final status = DateTime.now().second % 2 == 0;

final img = status
  ? ""
  : "";


    setState(() {
      fallDetected = status;
      imageUrl = img;
      isLoading = false;
    });

    if (status) {
      Future.delayed(Duration.zero, () {
        showFallAlert();
      });
    }
  }

  void showFallAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("🚨 Fall Detected!"),
          content: const Text("Please check the safety of the elderly person immediately."),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK", style: TextStyle(color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = fallDetected ? Colors.red : Colors.green;
    final text = fallDetected ? "⚠️ Fall detected!" : "✅ Safe";
    final icon = fallDetected ? Icons.warning : Icons.check_circle;

    return Scaffold(
      appBar: AppBar(
        title: Text("Status: ${widget.name}"),
        backgroundColor: color,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(icon, size: 80, color: color),
                    const SizedBox(height: 16),
                    Text(text, style: TextStyle(fontSize: 26, color: color)),
                    const SizedBox(height: 24),
                    if (imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(imageUrl!, width: 300),
                      ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: fetchStatus,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Refresh Status"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
