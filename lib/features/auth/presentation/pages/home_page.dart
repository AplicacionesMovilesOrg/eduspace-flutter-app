import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/core/ui/theme.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_state.dart';
import 'package:eduspace_flutter_app/features/classroom/presentation/blocs/classroom_cubit.dart';
import 'package:eduspace_flutter_app/features/classroom/presentation/widgets/classroom_card.dart';
import 'package:eduspace_flutter_app/presentation/widgets/side_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<ClassroomCubit>().loadClassrooms(authState.user.id);
    }
  }

  String _formatRole(String role) {
    return role.replaceAll('Role', '');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is Authenticated ? state.user : null;
        final username = user?.username ?? '';
        final role = user?.role ?? '';

        return Scaffold(
          backgroundColor: colorScheme.surface,
          drawer: const SideMenu(currentPage: 'home'),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              'Home',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: MaterialTheme.createLightGradient(),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: MaterialTheme.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: MaterialTheme.black1.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: MaterialTheme.createBrandGradient(),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: MaterialTheme.brandPrimary.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: MaterialTheme.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        username,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: MaterialTheme.brandPrimary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _formatRole(role),
                          style: const TextStyle(
                            color: MaterialTheme.brandPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ClassroomCubit, ClassroomState>(
                    builder: (context, classroomState) {
                      if (classroomState is ClassroomLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: MaterialTheme.brandPrimary,
                          ),
                        );
                      }

                      if (classroomState is ClassroomError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: MaterialTheme.stateError.withValues(
                                      alpha: 0.1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.error_outline,
                                    size: 60,
                                    color: MaterialTheme.stateError,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Error loading courses',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  classroomState.message,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    final authState = context.read<AuthBloc>().state;
                                    if (authState is Authenticated) {
                                      context
                                          .read<ClassroomCubit>()
                                          .loadClassrooms(authState.user.id);
                                    }
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Retry'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MaterialTheme.brandPrimary,
                                    foregroundColor: MaterialTheme.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (classroomState is ClassroomLoaded) {
                        if (classroomState.classrooms.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(30),
                                    decoration: BoxDecoration(
                                      gradient: MaterialTheme.createBrandGradient(),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: MaterialTheme.brandPrimary.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.class_outlined,
                                      size: 60,
                                      color: MaterialTheme.white,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'No courses assigned',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Your courses will appear here',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () async {
                            final authState = context.read<AuthBloc>().state;
                            if (authState is Authenticated) {
                              context
                                  .read<ClassroomCubit>()
                                  .loadClassrooms(authState.user.id);
                            }
                          },
                          color: MaterialTheme.brandPrimary,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: classroomState.classrooms.length,
                            itemBuilder: (context, index) {
                              return ClassroomCard(
                                classroom: classroomState.classrooms[index],
                              );
                            },
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
