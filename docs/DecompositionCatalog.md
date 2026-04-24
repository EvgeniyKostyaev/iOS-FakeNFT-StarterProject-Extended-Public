Костяев Евгений Анатольевич

Когорта: 33

Группа: 1

Эпик: Каталог

Ссылка на доску: https://github.com/users/EvgeniyKostyaev/projects/3

# Декомпозиция эпика Каталог

## Модуль 1 - Верстка экранов (est: 15 часов / fact: 17.5 часов):

#### Верстка экрана каталога коллекций CatalogView

Создание структуры каталога:

Создать папку UI/Catalog:

- CatalogView.swift
- CollectionCellView.swift
- CollectionDetailView.swift
- NFTItemCellView.swift

est: 0.5 часа / fact: 0.5 часов

Реализация экрана каталога:

Функциональность:

- NavigationStack
- List
- NavigationTitle

Показывает:
Список коллекций

est: 1.5 часа / fact: 0.5 часов

Создать модель коллекции:

- Создать CatalogViewData(id, name, cover, nftCount)

est: 0.5 часа / fact: 0.5 часов

Верстка ячейки коллекции:

- Создать CollectionCellView
- Верстка AsyncImage
- HStack
- VStack

est: 2.5 часа / fact: 3.0 часов

Подключение ячейки к List:

- отображение массива коллекций
- отображение названия
- отображение количества NFT

est: 1 час / fact: 1.5 часов

Реализовать интерфейс выбора сортировки:
- Добавить кнопку сортировки в NavigationBar
- Реализовать модальное окно(.sheet, ActionSheet / confirmationDialog)
- Добавить пункты: По названию / По количеству NFT / Закрыть

est: 2.5 часа / fact: 2 часов

Индикатор загрузки:

- Добавить ProgressView при состоянии loading

est: 0.5 часа / fact: 0.5 часов

Переход на экран коллекции:

- При нажатии на ячейку NavigationLink переход на CollectionDetailView

est: 0.5 часа / fact: 0.5 часов

#### Верстка экрана коллекции NFT

Создать экран коллекции CollectionDetailView:

Содержит:

- обложку
- название
- описание
- автор
- grid NFT

est: 1.5 часа / fact: 1.5 часов

Создать модель коллекции:

- Создать CollectionDetailViewData(id, author, description, NFTItems, ...)

est: 0.5 часа / fact: 1 час

Header коллекции:

- Верстка AsyncImage / название / описание

est: 1.5 часа / fact: 1 час

Кнопка автора:

- Добавить Link или WKWebView через UIViewRepresentable

est: 2 часа / fact: 0.5 часов

Grid NFT: 

- Использовать LazyVGrid 2–3 колонки

est: 1.5 часа / fact: 1 час

Верстка ячейки NFT:

- Создать NFTItemCellView
- Содержит: изображение / название / рейтинг / цену / кнопку избранного / кнопку корзины

est: 3 часа / fact: 2 часа

Добавить mock данные NFT: 

- массив NFT
- отображение в grid

est: 0.5 часов / fact: 1 часов

Переход на экран NFT:

- NavigationLink

est: 0.5 часов / fact: 0.5 часов
    

## Модуль 2 - Работа с сетью и данными (est: ~20 часов):

#### Настроить сеть

Подключить mock API:

- Заиспользовать NetworkClient / func request<T: Decodable>() / URLSession / async/await
- Заиспользовать сервис CatalogService (getCollections() / getCollectionNFTs())

est: 4 часа / fact: x часов

#### Модели API

Создать модели:

- Создать модель NFTCollectionDTO(id, name, cover, nfts)
- Создать модель NFTDTO(id, name, rating, price, image, isLiked) 

est: 2 часа  / fact: x часов

Маппинг DTO → Domain:

- extension NFTCollectionDTO
- extension NFTDTO

est: 1 час  / fact: x часов

#### ViewModel

CatalogViewModel:

- Создать CatalogueViewModel
- @Published var collections
- @Published var isLoading
- loadCollections()
- sortCollections()

est: 2.5 часа  / fact: x часов

CollectionDetailViewModel:

- Создать CollectionDetailViewModel
- @Published var nfts
- loadNFTs()

est: 2 часа  / fact: x часов

#### Подключение данных к UI

Подключить CatalogViewModel к CatalogView:

- Загрузка коллекций

est: 2 часа  / fact: x часов

Подключить CollectionDetailViewModel к CollectionDetailView:

- Загрузка NFT

est: 2 часа  / fact: x часов

Обработка состояния загрузки:

- loading
- success
- error

est: 2 часа  / fact: x часов

## Module 3 Логика взаимодействия пользователя (est: ~20 часов):

#### Избранное

Добавление NFT в избранное:

- Добавить кнопку "Like"
- Логика toggleFavorite()

est: 2 часа  / fact: x часов

Хранение избранного:

- Заиспользовать UserDefaults или AppStorage

est: 1.5 часа  / fact: x часов

#### Корзина

Добавление NFT в корзину:

- Добавить кнопку "Cart"
- Логика addToCart() / removeFromCart()

est: 2 часа  / fact: x часов

Изменение состояния кнопки корзины:

- если NFT в корзине → показать крестик

est: 1 час  / fact: x часов

#### Сортировка каталога

Сортировка коллекций:

- по названию
- по количеству NFT

est: 2 часа  / fact: x часов

Сохранение сортировки:

- Заиспользовать UserDefaults или AppStorage

est: 1 час  / fact: x часов

#### Сортировка NFT внутри коллекции

Реализовать сортировку grid:

- по названию
- по рейтингу
- по стоимости

est: 2 часа  / fact: x часов

#### Оптимизация

Обработка ошибок сети:

 - показ alert

est: 1 час  / fact: x часов

Рефакторинг:

- разделение сервисов
- чистка ViewModel

est: 2 часа  / fact: x часов


