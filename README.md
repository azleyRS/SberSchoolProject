# SberSchoolProject
Sber School Project

<p>
  <img src="https://raw.githubusercontent.com/azleyRS/SberSchoolProject/master/Simulator%20Screen%20Shot%20-%20iPhone%208%20-%202021-07-30%20at%2022.39.47.png" width="350">
  <img src="https://raw.githubusercontent.com/azleyRS/SberSchoolProject/master/Simulator%20Screen%20Shot%20-%20iPhone%208%20-%202021-07-30%20at%2022.39.51.png" width="350">
  <img src="https://raw.githubusercontent.com/azleyRS/SberSchoolProject/master/Simulator%20Screen%20Shot%20-%20iPhone%208%20-%202021-07-30%20at%2022.39.54.png" width="350">
  <img src="https://raw.githubusercontent.com/azleyRS/SberSchoolProject/master/Simulator%20Screen%20Shot%20-%20iPhone%208%20-%202021-07-30%20at%2022.39.57.png" width="350">

</p>

Приложение для просмотра прогноза погоды.
Позволяет:
1. Посмотреть текущую погоду относительно геопозиции
2. Посмотреть текущую погоду по названию города
3. Посмотреть прогноз погоды по текущей геопозиции
4. Посмотреть прогноз погоды по названию города
5. Сохранить текущий прогноз в CoreData
6. Просмотреть сохранненые прогнозы погоды

### Архитектура
MVP

## Выполнение поставленных требований:

Выполнены все, некоторые подписаны подробнее
- #### Использовать Core Data для хранения моделей данных
Экран c детальной инфорацией на 5 дней / 3 часа под капотом использует CoreData чтоб сохранить список с прогнозом погоды, экран со CollectionView использует FetchController для получения моделей.
- #### Использовать KeyChain/UserDefaults для пользовательских настроек (например пользовательский выбор фона)
Выбор фона на главном экране регулируется через маркет из UserDefaults
- #### Использование Swift styleguides (Google styleguides)
Выполнено
- #### Не использовать сторонние библиотеки
Выполнено
- #### Использовать сеть
Загрузка данных производится через сеть (https://openweathermap.org/)
- #### Загружать медиа из сети
Изображение с текущей погодой грузится из сети (https://openweathermap.org/)
- #### Минимальное количество экранов: 3
Главный экран, список с прогнозом погоды, таблица с сохраненной погодой
- #### Обязательно использовать UINavigationController/TabBarController
Используются оба
- #### Deployment Target: iOS 13
Выполнено
- #### Покрытие тестами 10 % и более
Выполнено
- #### Использование Архитектурных подходов и шаблонов проектирования
Выполнено
- #### Обязательно использовать UITableView / UICollectionView (один или оба)
Используются оба
Дополнительно - анимация флипа на последнем экране
