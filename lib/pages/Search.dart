import 'dart:async';
import 'package:flutter/material.dart';
import '../Services/WeatherServices.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _suggestions = [];
  bool _isLoading = false;
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchCity(query);
    });
  }

  Future<void> _searchCity(String query) async {
    if (query.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final results = await getCitySuggestions(query);
      setState(() {
        _suggestions = results;
        _isLoading = false;
      });
    } catch (e) {
      print("Erreur de recherche : $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 100),
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                hintText: 'Rechercher une ville',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withOpacity(0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator(color: Colors.white)
            else
              Expanded(
                child: _suggestions.isEmpty
                    ? const Text(
                  'Aucune suggestion',
                  style: TextStyle(color: Colors.white70),
                )
                    : ListView.builder(
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final city = _suggestions[index];
                    final name = city['name'];
                    final country = city['country'];
                    final state = city['state'] ?? '';

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.location_on, color: Colors.white),
                        title: Text(
                          "$name${state.isNotEmpty ? ', $state' : ''}, $country",
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          print("Ville choisie : $name");
                          Navigator.pop(context, name);
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
