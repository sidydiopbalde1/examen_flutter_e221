import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              // Layout desktop
              return Row(
                children: [
                  // Section gauche - Illustration/Branding
                  Expanded(
                    flex: 1,
                    child: _buildLeftSection(),
                  ),
                  // Section droite - Formulaire
                  Expanded(
                    flex: 1,
                    child: _buildLoginForm(),
                  ),
                ],
              );
            } else {
              // Layout mobile
              return _buildLoginForm();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLeftSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6F42C1),
            Color(0xFF9561E2),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo ou icône
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Icon(
                  Icons.apps,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              
              SizedBox(height: 32),
              
              Text(
                'Substance',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              SizedBox(height: 16),
              
              Text(
                'Gérez vos produits avec efficacité',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 48),
              
              // Statistiques ou features
              _buildFeatureItem(Icons.inventory_2, 'Gestion des stocks'),
              SizedBox(height: 16),
              _buildFeatureItem(Icons.analytics, 'Analyses avancées'),
              SizedBox(height: 16),
              _buildFeatureItem(Icons.security, 'Sécurité maximale'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        SizedBox(width: 16),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: EdgeInsets.all(48),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // En-tête
              Column(
                children: [
                  // Logo mobile
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFF6F42C1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.apps,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  Text(
                    'Connexion',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  
                  SizedBox(height: 8),
                  
                  Text(
                    'Connectez-vous à votre compte',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 32),
              
              // Formulaire
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    // Email
                    TextFormField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFF6F42C1), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir votre email';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Email invalide';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Mot de passe
                    Obx(() => TextFormField(
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: controller.togglePasswordVisibility,
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFF6F42C1), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir votre mot de passe';
                        }
                        if (value.length < 6) {
                          return 'Le mot de passe doit contenir au moins 6 caractères';
                        }
                        return null;
                      },
                    )),
                    
                    SizedBox(height: 16),
                    
                    // Se souvenir de moi / Mot de passe oublié
                    Row(
                      children: [
                        Obx(() => Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: (value) => controller.toggleRememberMe(),
                          activeColor: Color(0xFF6F42C1),
                        )),
                        Text('Se souvenir de moi'),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            // TODO: Implémenter mot de passe oublié
                          },
                          child: Text(
                            'Mot de passe oublié ?',
                            style: TextStyle(color: Color(0xFF6F42C1)),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Bouton de connexion
                    Obx(() => Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value 
                            ? null 
                            : controller.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6F42C1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isLoading.value
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                'Se connecter',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    )),
                    
                    SizedBox(height: 24),
                    
                    // Lien d'inscription
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Vous n'avez pas de compte ? ",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Naviguer vers la page d'inscription
                          },
                          child: Text(
                            'Créer un compte',
                            style: TextStyle(
                              color: Color(0xFF6F42C1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


