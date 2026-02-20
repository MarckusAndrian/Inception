<?php
// Database settings
define('DB_NAME', getenv('WORDPRESS_DB_NAME'));
define('DB_USER', getenv('WORDPRESS_DB_USER'));
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD'));
define('DB_HOST', getenv('WORDPRESS_DB_HOST'));

define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

// Authentication unique keys and salts
define('AUTH_KEY',         'put-your-unique-phrase-here-1');
define('SECURE_AUTH_KEY',  'put-your-unique-phrase-here-2');
define('LOGGED_IN_KEY',    'put-your-unique-phrase-here-3');
define('NONCE_KEY',        'put-your-unique-phrase-here-4');
define('AUTH_SALT',        'put-your-unique-phrase-here-5');
define('SECURE_AUTH_SALT', 'put-your-unique-phrase-here-6');
define('LOGGED_IN_SALT',   'put-your-unique-phrase-here-7');
define('NONCE_SALT',       'put-your-unique-phrase-here-8');

$table_prefix = 'wp_';

define('WP_DEBUG', false);
define('DISALLOW_FILE_EDIT', true);
define('FORCE_SSL_ADMIN', true);

// Absolute path
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');

require_once(ABSPATH . 'wp-settings.php');
