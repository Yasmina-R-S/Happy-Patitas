import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';

class LocalPictureService {
  /// Copia un archivo a la carpeta de documentos de la app y retorna el nombre del archivo
  Future<String> saveImageLocally(File file, String prefix) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
      final String filePath = path.join(directory.path, fileName);

      // Copiar el archivo
      await file.copy(filePath);
      debugPrint('LocalPictureService: Imagen guardada en $filePath');
      
      return fileName; // Retornamos solo el nombre para guardarlo en Firestore
    } catch (e) {
      debugPrint('LocalPictureService: Error al guardar imagen localmente: $e');
      rethrow;
    }
  }

  /// Obtiene la ruta completa a partir de un nombre de archivo
  Future<String?> getFullPath(String? fileName) async {
    if (fileName == null || fileName.isEmpty) return null;
    
    // Si ya es una URL (compatibilidad con datos viejos), la devolvemos tal cual
    if (fileName.startsWith('http')) return fileName;
    
    // Si es una ruta absoluta vieja (no recomendado, pero por si acaso)
    if (fileName.contains('/') || fileName.contains('\\')) {
       // Si el archivo existe, es una ruta absoluta
       if (File(fileName).existsSync()) return fileName;
       // Si no existe, intentamos extraer solo el nombre
       fileName = path.basename(fileName);
    }

    final directory = await getApplicationDocumentsDirectory();
    final String filePath = path.join(directory.path, fileName);
    
    if (File(filePath).existsSync()) {
      return filePath;
    }
    
    debugPrint('LocalPictureService: El archivo $fileName no existe en la ruta local');
    return null;
  }
}
