import 'package:flutter/material.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/loading_widget.dart';
import '../../data/models/kutcom_model.dart';
import '../../data/services/kutcom_service.dart';
import 'widgets/kutcom_card.dart';
import 'widgets/kutcom_group_tile.dart';
import 'widgets/filter_popup.dart';
import 'widgets/landing_drawer.dart';

enum FilterType { mySequence, unreadMessages, latest }

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final KutComService _kutComService = MockKutComService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<KutComGroup> _groups = [];
  List<KutComGroup> _filteredGroups = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String _searchQuery = '';
  FilterType _currentFilter = FilterType.mySequence;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final groups = await _kutComService.getKutComGroups();
      setState(() {
        _groups = groups;
        _filteredGroups = groups;
        _isLoading = false;
      });
      _applyFilter();
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilter() {
    var filtered = List<KutComGroup>.from(_groups);

    // Apply search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((g) {
        return g.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            g.kutcoms.any((k) =>
                k.name.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }

    // Apply sort
    switch (_currentFilter) {
      case FilterType.unreadMessages:
        filtered.sort((a, b) => b.totalUnread.compareTo(a.totalUnread));
        break;
      case FilterType.latest:
        filtered.sort((a, b) {
          final aTime = a.kutcoms
              .map((k) => k.lastActivity)
              .whereType<DateTime>()
              .fold<DateTime?>(null, (prev, curr) =>
                  prev == null || curr.isAfter(prev) ? curr : prev);
          final bTime = b.kutcoms
              .map((k) => k.lastActivity)
              .whereType<DateTime>()
              .fold<DateTime?>(null, (prev, curr) =>
                  prev == null || curr.isAfter(prev) ? curr : prev);
          if (aTime == null && bTime == null) return 0;
          if (aTime == null) return 1;
          if (bTime == null) return -1;
          return bTime.compareTo(aTime);
        });
        break;
      case FilterType.mySequence:
        // Default order
        break;
    }

    setState(() => _filteredGroups = filtered);
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _applyFilter();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
        _searchController.clear();
        _applyFilter();
      }
    });
  }

  void _showFilter() {
    showDialog(
      context: context,
      builder: (context) => FilterPopup(
        currentFilter: _currentFilter,
        onFilterChanged: (filter) {
          setState(() => _currentFilter = filter);
          _applyFilter();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const LandingDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  hintText: 'Search KutCom...',
                  hintStyle:
                      TextStyle(color: AppColors.white.withValues(alpha: 0.7)),
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged,
              )
            : const Text('EntryTUD'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilter,
          ),
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.danger,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.notifications);
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  Navigator.of(context).pushNamed(AppRoutes.settings);
                  break;
                case 'schedule':
                  Navigator.of(context).pushNamed(AppRoutes.schedule);
                  break;
                case 'language':
                  Navigator.of(context).pushNamed(AppRoutes.languageSettings);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'schedule',
                child: Row(
                  children: [
                    Icon(Icons.schedule, color: AppColors.text, size: 20),
                    SizedBox(width: 12),
                    Text('Set Schedule'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'language',
                child: Row(
                  children: [
                    Icon(Icons.language, color: AppColors.text, size: 20),
                    SizedBox(width: 12),
                    Text('Language Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: AppColors.text, size: 20),
                    SizedBox(width: 12),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Loading KutComs...');
    }

    if (_filteredGroups.isEmpty && _searchQuery.isNotEmpty) {
      return const EmptyStateWidget(
        message: AppStrings.noResultsFound,
        icon: Icons.search_off,
      );
    }

    if (_groups.isEmpty) {
      return _buildNewUserView();
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _filteredGroups.length,
        itemBuilder: (context, index) {
          final group = _filteredGroups[index];
          if (group.type == KutComGroupType.individual) {
            return KutComCard(
              kutcom: group.kutcoms.first,
              onTap: () => _navigateToDetail(group.kutcoms.first),
            );
          }
          return KutComGroupTile(
            group: group,
            onKutComTap: _navigateToDetail,
          );
        },
      ),
    );
  }

  Widget _buildNewUserView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, size: 64, color: AppColors.primary),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    AppStrings.tudMessage,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.settings);
                    },
                    child: const Text(AppStrings.createTudAccount),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppStrings.roleHolderMessage,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(KutComModel kutcom) {
    Navigator.of(context).pushNamed(
      AppRoutes.kutcomDetail,
      arguments: kutcom,
    );
  }
}
