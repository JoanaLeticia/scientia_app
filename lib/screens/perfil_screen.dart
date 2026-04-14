import 'package:flutter/material.dart';
import 'package:scientia_app/screens/home_screen.dart';
import 'package:scientia_app/screens/pesquisa_screen.dart';
import 'package:scientia_app/screens/aulas_screen.dart';
import 'package:scientia_app/screens/wishlist_screen.dart';
import 'login_screen.dart';
import 'notificacoes_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Meu Perfil",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificacoesScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0EDFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none,
                        color: Color(0xFF0066F5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.orange.shade100,
                backgroundImage: const NetworkImage(
                  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80',
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Joana Letícia",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              const Text(
                "@joanaleticia",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              _buildMenuButton(
                icon: Icons.edit_outlined,
                title: "Editar Perfil",
              ),
              const SizedBox(height: 5),
              _buildMenuButton(
                icon: Icons.dns_outlined,
                title: "Dados Pessoais",
              ),
              const SizedBox(height: 5),
              _buildMenuButton(
                icon: Icons.settings_outlined,
                title: "Configurações da Conta",
              ),

              const SizedBox(height: 10),
              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 10),

              _buildMenuButton(
                icon: Icons.book_outlined,
                title: "Termos de Uso",
              ),
              const SizedBox(height: 5),
              _buildMenuButton(
                icon: Icons.headset_mic_outlined,
                title: "Suporte",
              ),

              const SizedBox(height: 40),

              _buildMenuButton(
                icon: Icons.logout,
                title: "Sair",
                textColor: Colors.red,
                borderColor: Colors.red,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF0066F5),
            unselectedItemColor: Colors.grey,
            iconSize: 28,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            currentIndex: 4,

            onTap: (index) {
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              } else if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PesquisaScreen(),
                  ),
                );
              } else if (index == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WishlistScreen(),
                  ),
                );
              } else if (index == 3) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AulasScreen(),
                  ),
                );
              }
            },

            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Pesquisar",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: "Wishlist",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: "Aulas",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Perfil",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    Color textColor = Colors.black87,
    Color borderColor = const Color(0xFFE0E0E0),
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 24),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
