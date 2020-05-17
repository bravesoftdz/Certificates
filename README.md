# База по нетарифке

Может помочь в работе специалистам в области ВЭД.
Позволяет производить быстрый поиск по разрешительной документации по полям:
 
* номер документа;
* изготовитель
* наименование продукции
* маркировка
* код ТН ВЭД ЕАЭС

[Скачать архив (7z) с программой.](https://github.com/scbeast/Certificates/blob/master/Release/Certificates.7z)

Распаковать в любое место и можно пользоваться.

***

### О программе

На скринах ниже показаны элементы управления и их назначение:

![Список документов](https://github.com/scbeast/Certificates/blob/master/Release/about/СКРИН01.png "Список документов")

При двойном щелчке на элементе списка откроется вторая вкладка "Подробная информация":

![Подробная информация](https://github.com/scbeast/Certificates/blob/master/Release/about/СКРИН02.png "Подробная информация")

При помощи "Главного меню" выбирается расположение источника (файла с информацией) - на локальной машине или на удалённом сервере (например для организации работы несколькими специалистами и обновления информации централизованно).

![Пункт меню Файл](https://github.com/scbeast/Certificates/blob/master/Release/about/СКРИН03.png "Пункт меню Файл")

Программа запомнит выбор и при следующем запуске по нажатию кнопки "Загрузить данные" произведёт загрузку из обозначенного места.
Можно расположить файлы в [Google Drive][1] или [Dropbox][2], предоставить неограниченный доступ, скопировать ссылку и всавить в поле ввода.

[1]: https://drive.google.com/ "Google Drive"
[2]: https://www.dropbox.com/ "Dropbox"

В списке документов быстрый поиск работает без учёта регистра символов. В подробной информации поиск уже чувствителен к регистру.

Сам источник представляет собой файл формата JSON. В папке с программой находится пример такого файла.

> _Редактировать можно в любом текстовом редакторе или онлайн_. _Например на этом ресурсе_:

> [JSON Editor Online](https://jsoneditoronline.org/ "JSON Editor Online")

> _К тому же такой редактор покажет ошибки_, _которые можно допустить при заполнении_.

Пример с описанием:

![JSON](https://github.com/scbeast/Certificates/blob/master/Release/about/JSON.png "JSON")

> _Кодировка файла должна быть либо UTF-8 c BOM_, _либо CP-1251_.

Вроде всё. Надеюсь, программа поможет сэкономить время в повседневной работе.

Удачи в делах!

***

Использованы приёмы, материалы, советы, решения, модули:

* [JSON Editor Online](https://jsoneditoronline.org/)
* [БЕСПЛАТНЫЕ РЕСУРСЫ И ПРОГРАММЫ ДЛЯ ДИЗАЙНА](https://icons8.ru/)
* [IDERA Community](https://community.idera.com/)
* [Embarcadero/IDERA Documentation Wiki](http://docwiki.embarcadero.com/)
* [Форумы - Fire Monkey от А до Я](http://fire-monkey.ru/)
* [FireMonkey Modern ListView - Colorizer, Vertical\Horizontal mode, Columns and other](https://github.com/rzaripov1990/ModernListView)
***
Embarcadero® Delphi 10.3 Community Edition, FireMonkey

Связь с автором: [scbeast-develop@yandex.ru](mailto:scbeast-develop@yandex.ru)
***
