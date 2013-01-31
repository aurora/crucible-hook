<?php

define('GIT_REPOS', '/var/git');

if (!isset($_GET['a'])) die('missing "a"');

// repository
$r = (isset($_GET['r']) && preg_match('/^[^ \/]+\.git$/', ($r = basename($_GET['r'])))
        ? $r
        : false);

// branch
$b = (isset($_GET['b']) && !preg_match('/[^a-z0-9-_]/', $_GET['b'])
        ? $_GET['b'] 
        : false);   

// commit
$c = (isset($_GET['c']) && preg_match('/^[a-f0-9]{7}$/', $_GET['c'])
        ? $_GET['c']
        : false);

if (!$r || !$b || !$c || !is_dir(GIT_REPOS . '/' . $r)) {
    die('invalid "r", "b" or "c"');
}

switch ($_GET['a']) {
case 'diff':
    chdir(GIT_REPOS . '/' . $r);
    passthru(sprintf(
        'git diff %s',
        escapeshellarg($c . '^!')
    ));
    break;
default:
    die('unknown "a"');
}

