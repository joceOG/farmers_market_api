<?php

use App\Models\Category;

// 1. Catégories racines
$roots = [
    ['name' => 'Pesticides'],
    ['name' => 'Engrais'],
    ['name' => 'Semences'],
    ['name' => 'Matériels'],
];

$rootIds = [];
foreach ($roots as $r) {
    $cat = Category::updateOrCreate(
        ['name' => $r['name'], 'parent_id' => null],
        ['name' => $r['name'], 'parent_id' => null]
    );
    $rootIds[$r['name']] = $cat->id;
    echo "✅ {$r['name']} créé (ID {$cat->id})\n";
}

// 2. Sous-catégories
$allSubs = [
    ['name' => 'Herbicides',                  'parent_id' => $rootIds['Pesticides']],
    ['name' => 'Fongicides',                  'parent_id' => $rootIds['Pesticides']],
    ['name' => 'Insecticides',                'parent_id' => $rootIds['Pesticides']],
    ['name' => 'Hematicides',                 'parent_id' => $rootIds['Pesticides']],

    ['name' => 'Engrais Organiques',          'parent_id' => $rootIds['Engrais']],
    ['name' => 'NPK (Nitrogène, Phosphore, Potasse)', 'parent_id' => $rootIds['Engrais']],
    ['name' => 'Engrais Chimiques',           'parent_id' => $rootIds['Engrais']],
    ['name' => 'Engrais Liquides Foliaires',  'parent_id' => $rootIds['Engrais']],

    ['name' => 'Semences de Cacao',           'parent_id' => $rootIds['Semences']],
    ['name' => 'Semences de Café',            'parent_id' => $rootIds['Semences']],
    ['name' => 'Semences Légumes',            'parent_id' => $rootIds['Semences']],
    ['name' => 'Semences Céréales',           'parent_id' => $rootIds['Semences']],
    ['name' => 'Semences Oléagineux',         'parent_id' => $rootIds['Semences']],

    ['name' => 'Outils Agricoles',            'parent_id' => $rootIds['Matériels']],
    ['name' => "Équipements d'Irrigation",    'parent_id' => $rootIds['Matériels']],
    ['name' => 'Équipements de Stockage',     'parent_id' => $rootIds['Matériels']],
    ['name' => 'Petit Matériel Motorisé',     'parent_id' => $rootIds['Matériels']],
];

foreach ($allSubs as $sub) {
    $c = Category::updateOrCreate(
        ['name' => $sub['name'], 'parent_id' => $sub['parent_id']],
        ['name' => $sub['name'], 'parent_id' => $sub['parent_id']]
    );
    echo "✅ {$sub['name']} (parent {$sub['parent_id']}) créée\n";
}

echo "\n🎉 Hiérarchie catégories prête !\n";