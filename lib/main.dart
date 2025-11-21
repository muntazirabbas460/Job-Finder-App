// ignore_for_file: library_private_types_in_public_api


import 'package:flutter/material.dart';

void main() {
  runApp(JobFinderApp());
}

class JobFinderApp extends StatelessWidget {
  const JobFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Job Finder App',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: HomePage(),
    );
  }
}

// ========================= DATA MODEL ===========================

class Job {
  String title;
  String company;
  String category;
  String location;
  String description;

  Job({
    required this.title,
    required this.company,
    required this.category,
    required this.location,
    required this.description,
  });
}

// In-memory list of jobs (mock database)
List<Job> jobs = [
  Job(
    title: 'Flutter Developer',
    company: 'TechSoft',
    category: 'IT',
    location: 'Karachi',
    description: 'Build and maintain mobile applications using Flutter.',
  ),
  Job(
    title: 'Graphic Designer',
    company: 'Creative Studio',
    category: 'Design',
    location: 'Lahore',
    description: 'Create modern graphics and UI assets.',
  ),
  Job(
    title: 'Data Analyst',
    company: 'DataPro',
    category: 'Analytics',
    location: 'Islamabad',
    description: 'Analyze data and produce reports.',
  ),
];

// ========================= HOME PAGE ===========================

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "All";
  String selectedLocation = "All";
  String searchQuery = "";

  List<String> categories = ["All", "IT", "Design", "Analytics", "Business"];
  List<String> locations = ["All", "Karachi", "Lahore", "Islamabad"];

  @override
  Widget build(BuildContext context) {
    List<Job> filteredJobs = jobs.where((job) {
      bool matchesCategory =
          selectedCategory == "All" || job.category == selectedCategory;
      bool matchesLocation =
          selectedLocation == "All" || job.location == selectedLocation;
      bool matchesSearch =
          job.title.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesCategory && matchesLocation && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Job Finder"),
        actions: [
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AdminPage()),
              );
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [

            // ----------- SEARCH BAR -------------
            TextField(
              decoration: InputDecoration(
                  hintText: "Search job title...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder()),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 12),

            // ----------- FILTERS -------------
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(),
                    ),
                    items: categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField(
                    value: selectedLocation,
                    decoration: InputDecoration(
                      labelText: "Location",
                      border: OutlineInputBorder(),
                    ),
                    items: locations
                        .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedLocation = value!;
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // ---------------- JOB LIST ----------------
            Expanded(
              child: filteredJobs.isEmpty
                  ? Center(child: Text("No jobs found"))
                  : ListView.builder(
                      itemCount: filteredJobs.length,
                      itemBuilder: (_, index) {
                        final job = filteredJobs[index];
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            title: Text(job.title),
                            subtitle: Text("${job.company} • ${job.location}"),
                            trailing: ElevatedButton(
                              child: Text("Apply"),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Applied to ${job.title}!")),
                                );
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => JobDetailPage(job: job),
                                ),
                              );
                            },
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

// ========================= JOB DETAILS ===========================

class JobDetailPage extends StatelessWidget {
  final Job job;
  const JobDetailPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(job.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.company, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("${job.category} • ${job.location}"),
            SizedBox(height: 20),
            Text("Job Description:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(job.description),
            Spacer(),
            Center(
              child: ElevatedButton(
                child: Text("Apply Now"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Application submitted!")),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ========================= ADMIN PAGE (POST JOB) ===========================

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final titleCtrl = TextEditingController();
  final companyCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  String category = "IT";
  String location = "Karachi";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin - Post Job")),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(labelText: "Job Title", border: OutlineInputBorder()),
            ),
            SizedBox(height: 12),

            TextField(
              controller: companyCtrl,
              decoration: InputDecoration(labelText: "Company", border: OutlineInputBorder()),
            ),
            SizedBox(height: 12),

            DropdownButtonFormField(
              value: category,
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Category"),
              items: ["IT", "Design", "Analytics", "Business"]
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) => setState(() => category = value!),
            ),
            SizedBox(height: 12),

            DropdownButtonFormField(
              value: location,
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Location"),
              items: ["Karachi", "Lahore", "Islamabad"]
                  .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                  .toList(),
              onChanged: (value) => setState(() => location = value!),
            ),
            SizedBox(height: 12),

            TextField(
              controller: descCtrl,
              maxLines: 4,
              decoration: InputDecoration(labelText: "Description", border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              child: Text("Post Job"),
              onPressed: () {
                if (titleCtrl.text.isEmpty || companyCtrl.text.isEmpty || descCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }

                jobs.add(Job(
                  title: titleCtrl.text,
                  company: companyCtrl.text,
                  category: category,
                  location: location,
                  description: descCtrl.text,
                ));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Job posted successfully")),
                );

                titleCtrl.clear();
                companyCtrl.clear();
                descCtrl.clear();
              },
            )
          ],
        ),
      ),
    );
  }
}