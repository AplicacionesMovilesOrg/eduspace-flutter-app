import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_state.dart';
import 'package:eduspace_flutter_app/features/classroom/presentation/blocs/classroom_cubit.dart';
import 'package:eduspace_flutter_app/features/classroom/presentation/widgets/classroom_card.dart';
// Classroom detail navigation removed; cards are now read-only
import 'package:eduspace_flutter_app/presentation/widgets/side_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color eduBlue = Color(0xFF1E88E5);

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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is Authenticated ? state.user : null;
        final username = user?.username ?? '';
        final role = user?.role ?? '';

        return Scaffold(
          backgroundColor: Colors.white,
          drawer: const SideMenu(),
          appBar: AppBar(
            title: const Text(
              'EduSpace Teacher',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: true,
            backgroundColor: eduBlue,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: const BoxDecoration(
                  color: eduBlue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 50, color: eduBlue),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 4),
                    Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white,
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
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _formatRole(role),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
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
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (classroomState is ClassroomError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading courses',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                              ),
                              child: Text(
                                classroomState.message,
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (classroomState is ClassroomLoaded) {
                      if (classroomState.classrooms.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.class_outlined,
                                size: 64,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No courses assigned',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: classroomState.classrooms.length,
                        itemBuilder: (context, index) {
                          return ClassroomCard(
                            classroom: classroomState.classrooms[index],
                          );
                        },
                      );
                    }

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.class_outlined,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Your courses will appear here',
                            style: TextStyle(color: Colors.grey.shade500),
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
      },
    );
  }
}
