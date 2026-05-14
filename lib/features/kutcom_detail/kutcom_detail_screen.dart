import 'package:flutter/material.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/avatar_widget.dart';
import '../../core/widgets/badge_widget.dart';
import '../../core/widgets/loading_widget.dart';
import '../../data/models/kutcom_model.dart';
import '../../data/models/kut_model.dart';
import '../../data/services/kutcom_service.dart';

enum KutComFilter { unreadMessages, activeInterests, latest }

class KutComDetailScreen extends StatefulWidget {
  const KutComDetailScreen({super.key});

  @override
  State<KutComDetailScreen> createState() => _KutComDetailScreenState();
}

class _KutComDetailScreenState extends State<KutComDetailScreen> {
  final KutComService _service = MockKutComService();
  KutComModel? _kutcom;
  List<KutModel> _kuts = [];
  List<KutModel> _filteredKuts = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String _searchQuery = '';
  KutComFilter _currentFilter = KutComFilter.unreadMessages;
  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is KutComModel && _kutcom == null) {
      _kutcom = args;
      _loadKuts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadKuts() async {
    if (_kutcom == null) return;
    setState(() => _isLoading = true);
    final kuts = await _service.getKutsForKutCom(_kutcom!.id);
    setState(() {
      _kuts = kuts;
      _filteredKuts = kuts;
      _isLoading = false;
    });
    _applyFilter();
  }

  void _applyFilter() {
    var filtered = List<KutModel>.from(_kuts);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((k) =>
          k.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    switch (_currentFilter) {
      case KutComFilter.unreadMessages:
        filtered.sort((a, b) => b.unreadMessages.compareTo(a.unreadMessages));
        break;
      case KutComFilter.activeInterests:
        filtered.sort((a, b) {
          if (a.hasActiveInterest && !b.hasActiveInterest) return -1;
          if (!a.hasActiveInterest && b.hasActiveInterest) return 1;
          return 0;
        });
        break;
      case KutComFilter.latest:
        filtered.sort((a, b) {
          if (a.lastActivity == null && b.lastActivity == null) return 0;
          if (a.lastActivity == null) return 1;
          if (b.lastActivity == null) return -1;
          return b.lastActivity!.compareTo(a.lastActivity!);
        });
        break;
    }

    setState(() => _filteredKuts = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  hintText: 'Search Kuts...',
                  hintStyle:
                      TextStyle(color: AppColors.white.withValues(alpha: 0.7)),
                  border: InputBorder.none,
                ),
                onChanged: (q) {
                  _searchQuery = q;
                  _applyFilter();
                },
              )
            : Text(_kutcom?.name ?? 'KutCom Detail'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                  _applyFilter();
                }
              });
            },
          ),
          PopupMenuButton<KutComFilter>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() => _currentFilter = value);
              _applyFilter();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: KutComFilter.unreadMessages,
                child: Text('Unread Messages'),
              ),
              const PopupMenuItem(
                value: KutComFilter.activeInterests,
                child: Text('Active Interests'),
              ),
              const PopupMenuItem(
                value: KutComFilter.latest,
                child: Text('Latest'),
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              // Handle kebab menu items
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'common_msg', child: Text('Common Message')),
              PopupMenuItem(value: 'add_kut', child: Text('Add Kut')),
              PopupMenuItem(value: 'exit', child: Text('Exit KutCom')),
            ],
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Loading Kuts...');
    }

    if (_filteredKuts.isEmpty) {
      return EmptyStateWidget(
        message: _searchQuery.isNotEmpty
            ? AppStrings.noResultsFound
            : 'No Kuts in this KutCom',
        icon: Icons.people_outline,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadKuts,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _filteredKuts.length,
        itemBuilder: (context, index) {
          return _KutCard(
            kut: _filteredKuts[index],
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.chat,
                arguments: {
                  'kut': _filteredKuts[index],
                  'kutcom': _kutcom,
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _KutCard extends StatelessWidget {
  final KutModel kut;
  final VoidCallback onTap;

  const _KutCard({required this.kut, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Stack(
                children: [
                  AvatarWidget(name: kut.name, size: 48),
                  if (kut.isHTud)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.link,
                          size: 10,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            kut.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (kut.isHTud)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'HTud',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.success,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (kut.hasActiveInterest)
                          Row(
                            children: [
                              Icon(
                                Icons.pan_tool_alt,
                                size: 14,
                                color: AppColors.activeInterest,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Active',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.activeInterest,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (kut.unreadMessages > 0)
                BadgeWidget(count: kut.unreadMessages),
            ],
          ),
        ),
      ),
    );
  }
}
