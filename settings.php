<?php
/**
 * Konfigurasi Backdrop untuk Docker.
 * Semua credential dibaca dari environment variable (dari file .env),
 * jadi tidak ada password yang tertulis di file ini.
 */

$database = array(
  'database' => getenv('DB_NAME'),
  'username' => getenv('DB_USER'),
  'password' => getenv('DB_PASSWORD'),
  'host'     => 'db',      // nama service database di docker-compose.yml
);

// Lokasi folder konfigurasi (harus sama dengan yang dibuat di Dockerfile)
$config_directories['active']  = 'files/config/active';
$config_directories['staging'] = 'files/config/staging';

// String acak untuk keamanan, diambil dari .env
$settings['hash_salt'] = getenv('HASH_SALT');
