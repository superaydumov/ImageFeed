## Image Feed

## Ссылки

[Дизайн в Figma](https://www.figma.com/file/HyDfKh5UVPOhPZIhBqIm3q/Image-Feed-(YP)?type=design&node-id=334-4892&mode=design&t=GfpSiAyyIusqeuGX-0)
[Unsplash API](https://unsplash.com/documentation)

Изображения

Изображение 1
Изображение 2
Изображение 3
Изображение 4

Назначение и цели приложения

Многостраничное приложение предназначено для просмотра изображений через API Unsplash.

Цели приложения:

Просмотр бесконечной ленты картинок из Unsplash Editorial.
Просмотр краткой информации из профиля пользователя.
Краткое описание приложения

В приложении обязательна авторизация через OAuth Unsplash.
Главный экран состоит из ленты с изображениями. Пользователь может просматривать ее, добавлять и удалять изображения из избранного.
Пользователи могут просматривать каждое изображение отдельно и делиться ссылкой на них за пределами приложения.
У пользователя есть профиль с избранными изображениями и краткой информацией о пользователе.
У приложения есть две версии: расширенная и базовая. В расширенной версии добавляется механика избранного и возможность лайкать фотографии при просмотре изображения на весь экран.
Функциональные требования

Авторизация через OAuth

Для входа в приложение пользователь должен авторизоваться через OAuth.

Экран авторизации содержит:

Логотип приложения
Кнопку «Войти»
Алгоритмы и доступные действия:

При входе в приложение пользователь видит splash-screen;
После загрузки приложения открывается экран с возможностью авторизации;
При нажатии на кнопку «Войти» открывается браузер на странице авторизации Unsplash;
При нажатии на кнопку «Login» браузер закрывается. В приложении появляется экран загрузки;
Если авторизация через OAuth Unsplash не настроена, по нажатию на кнопку логина ничего не происходит;
Если авторизация через OAuth Unsplash настроена не корректно — пользователь не сможет войти в приложение;
При неудачной попытке входа всплывает модальное окно с ошибкой;
При нажатии на «ОК» пользователь переходит обратно на экран авторизации;
Если авторизация прошла успешно, то браузер закрывается. В приложении открывается экран с лентой.
Просмотр ленты

В ленте пользователь может просматривать изображения в ленте, переходить к просмотру отдельного изображения и добавлять их в избранное.

Экран ленты содержит:

Карточку с изображением;
Кнопку Лайк;
Дата загрузки фотографии;
Таб бар для навигации между лентой и профилем.
Алгоритмы и доступные действия:

Экран с лентой открывается по умолчанию после входа в приложение;
Лента содержит изображения из Unsplash Editorial;
При скролле вниз и вверх пользователь может просматривать ленту;
Если изображение не успело загрузиться, то пользователю отображается системный лоадер;
Если изображение невозможно загрузить – пользователь видит плэйсхолдер вместо изображения;
При нажатии на кнопку Лайк (серое сердечко) пользователь может лайнкуть изображение. После нажатия отображается лоадер:
Если запрос успешный, то лоадер пропадает, иконка меняет состояние на Кнопку Красный Лайк (красное сердечко).
Если запрос не успешный, то всплывает модальное окно с ошибкой «попробуйте еще раз»
Пользователь может убрать лайк, повторно нажав на кнопку Лайк (красное сердечко). После нажатия отображается лоадер:
Если запрос успешный, то лоадер пропадает, иконка меняет состояние на серое сердечко.
Если запрос не успешный, то всплывает модальное окно с ошибкой «попробуйте еще раз»;
При нажатии на карточку с изображением оно увеличится до границ телефона и пользователь перейдет на экран просмотра изображения (раздел «Просмотр изображения на весь экран»);
При нажатии на иконку профиля пользователь может перейти в профиль;
Пользователь может переключаться между экранами ленты и профиля с помощью таб бара.
Просмотр изображения на весь экран

Из ленты пользователь может перейти к просмотру изображения на весь экран и поделиться им.

Экран содержит:

Увеличенное изображение до границ телефона;
Кнопку возврата на предыдущий экран;
Кнопку для загрузки изображения и с возможностью им поделиться.
Алгоритмы и доступные действия:

При открытии изображения на весь экран пользователь видит растянутое изображение до границ экрана. Изображение выровнено по центру;
Если изображение невозможно загрузить и показать – пользователь видит плэйсхолдер;
Если ответ на запрос не получен — появляется системный алерт с ошибкой;
При нажатии на кнопку Назад пользователь может вернуться на экран просмотра ленты;
При помощи жестов пользователь может перемещаться по растянутому изображению, зумировать и поворачивать изображение. Изображение фиксируется в выбранном положении;
Если не настроены жесты для увеличения или поворота изображения — эти действия будут не доступны;
При нажатии на кнопку кнопку Поделиться всплывает системное меню, в котором пользователь может загрузить изображение или поделиться им;
После совершения действия меню скрывается;
Пользователь может закрыть меню свайпом вниз или при нажатии на крестик;
Если открытие системного меню при нажатии на кнопку “загрузить или поделиться изображением” не настроено — оно не будет показываться;
Просмотр профиля пользователя

Пользователь может перейти в свой профиль, чтобы посмотреть данные профиля или выйти из него.

Экран профиля содержит:

Данные профиля;
Фотографию пользователя;
Имя и username пользователя;
Информация о себе;
Кнопку выхода из профиля;
Таб бар;
Алгоритмы и доступные действия:

Данные профиля загружаются из профиля в Unsplash. Данные профиля нельзя изменить в приложении;
Если данные профиля не подтянулись из Unsplash, то пользователь видит плэйсхолдер вместо аватрки. Username и имя не отображаются;
При нажатии на кнопку выхода из профиля (логаут) пользователь может выйти из приложения. Всплывает системный алерт с подтверждением выхода;
Если пользователь нажимает «Да», то он разлогинивается и открывается экран авторизации;
Если не настроены или настроены неправильно действия с кнопкой «Да», то при нажатии пользователя не разлогинивается и попадает на экран авторизации;
Если пользователь нажимает «Нет», то он возвращается на экран профиля;
Если алерт не настроен, то при нажатии на кнопку выходы ничего не происходит, пользователь не может разлогиниться;
Пользователь может переключаться между экранами ленты и профиля с помощью таб бара.
Расширенная версия (не реализована)

Добавление изображения в избранное

В расширенной версии приложения при нажатии на лайк пользователь добавляет изображение в избранное. Избранное отображается в профиле пользователя.

При нажатии на кнопку Лайк (серое сердечко) приложение делает запрос на добавление изображения в избранное (не показывая индикатор загрузки). При успешном запросе иконка меняет состояние и изображение добавляется в избранное;
Если запрос на лайк неуспешный, то иконка не меняет свое состояние. Изображение в избранное не добавляется;
Если запрос на добавление в избранное неуспешный, то иконка не меняет свое состояние. Лайк не ставится;
При повторном нажатии на кнопку Лайк (красное сердечко) пользователь может удалить изображение из избранного;
Если запрос на удаление лайка неуспешный, то иконка не меняет свое состояние. Изображение не удаляется из избранного;
Если запрос на удаление изображения из избранного неуспешный, то иконка не меняет свое состояние. Лайк не удаляется;
Пользователь может добавить изображение в избранное при просмотре изображения на весь экран. В расширенной версии добавляется иконка лайка;
Пользователь может просмотреть избранное в профиле. Избранное отображается под данными пользователя.
Рядом с заголовком «Избранное» отображается счетчик количества изображений;
При скролле вниз и вверх пользователь может просматривать ленту с избранными фотографиями. Данные профиля не зафиксированы и скрываются при скролле;
Если изображение не успело загрузиться, то пользователю отображается системный лоадер;
Если изображение невозможно загрузить – пользователь видит плэйсхолдер вместо изображения;
Если фотографии отсутствуют, то пользователь видит плэйсхолдер;
При нажатии на кнопку Лайк пользователь может удалить изображение из избранного. В основной ленте лайк тоже удалится;
Пользователь может просмотреть изображение на весь экран;
Нефункциональные требования

Технические требования

Авторизация работает через OAuth Unsplash и POST запрос для получения Auth Token.
Лента реализована с помощью UITableView.
В приложении использованы UImageView, UIButton, UILabel, TabBarController, NavigationController, NavigationBar, UITableView, UITableViewCell.
Приложение должно поддерживать устройства iPhone с iOS 13 или выше, предусмотрен только портретный режим.
