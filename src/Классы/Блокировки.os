Перем Кластер_Агент;
Перем Кластер_Владелец;
Перем ИБ_Владелец;
Перем Сеанс_Владелец;
Перем Соединение_Владелец;

Перем ПараметрыОбъекта;
Перем Элементы;

Перем Лог;

// Конструктор
//   
// Параметры:
//   АгентКластера	- АгентКластера			- ссылка на родительский объект агента кластера
//   Кластер		- Кластер				- ссылка на родительский объект кластера
//   ИБ				- ИнформационнаяБаза	- ссылка на родительский объект информационной базы
//   Сеанс			- ИнформационнаяБаза	- ссылка на родительский объект сеанса
//   Соединение		- ИнформационнаяБаза	- ссылка на родительский объект соединения
//
Процедура ПриСозданииОбъекта(АгентКластера, Кластер, ИБ = Неопределено, Сеанс = Неопределено, Соединение = Неопределено)

	Кластер_Агент		= АгентКластера;
	Кластер_Владелец	= Кластер;
	ИБ_Владелец			= ИБ;
	Сеанс_Владелец		= Сеанс;
	Соединение_Владелец	= Соединение;

	ПараметрыОбъекта = Новый ПараметрыОбъекта("lock");

	Элементы = Новый ОбъектыКластера(ЭтотОбъект);

КонецПроцедуры // ПриСозданииОбъекта()

// Процедура получает данные от сервиса администрирования кластера 1С
// и сохраняет в локальных переменных
//   
// Параметры:
//   ОбновитьПринудительно 		- Булево	- Истина - принудительно обновить данные (вызов RAC)
//											- Ложь - данные будут получены если истекло время актуальности
//													или данные не были получены ранее
//   
Процедура ОбновитьДанные(ОбновитьПринудительно = Ложь) Экспорт
	
	Если НЕ Элементы.ТребуетсяОбновление(ОбновитьПринудительно) Тогда
		Возврат;
	КонецЕсли;

	ПараметрыЗапуска = Новый Массив();
	ПараметрыЗапуска.Добавить(Кластер_Агент.СтрокаПодключения());

	ПараметрыЗапуска.Добавить("lock");
	ПараметрыЗапуска.Добавить("list");

	ПараметрыЗапуска.Добавить(СтрШаблон("--cluster=%1", Кластер_Владелец.Ид()));
	ПараметрыЗапуска.Добавить(Кластер_Владелец.СтрокаАвторизации());

	Если НЕ ИБ_Владелец = Неопределено Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--infobase=%1", ИБ_Владелец.Ид()));
	КонецЕсли;

	Если НЕ Сеанс_Владелец = Неопределено Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--session=%1", Сеанс_Владелец.Получить("session")));
	КонецЕсли;

	Если НЕ Соединение_Владелец = Неопределено Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--connection=%1", Соединение_Владелец.Получить("connection")));
	КонецЕсли;

	Кластер_Агент.ВыполнитьКоманду(ПараметрыЗапуска);
	
	Элементы.Заполнить(Кластер_Агент.ВыводКоманды());

	Элементы.УстановитьАктуальность();

КонецПроцедуры // ОбновитьДанные()

// Функция возвращает коллекцию параметров объекта
//   
// Параметры:
//   ИмяПоляКлюча 		- Строка	- имя поля, значение которого будет использовано
//									  в качестве ключа возвращаемого соответствия
//   
// Возвращаемое значение:
//	Соответствие - коллекция параметров объекта, для получения/изменения значений
//
Функция ПараметрыОбъекта(ИмяПоляКлюча = "ИмяПараметра") Экспорт

	Возврат ПараметрыОбъекта.Получить(ИмяПоляКлюча);

КонецФункции // ПараметрыОбъекта()

// Функция возвращает список блокировок
//   
// Параметры:
//   Отбор					 	- Структура	- Структура отбора блокировок (<поле>:<значение>)
//   ОбновитьПринудительно 		- Булево	- Истина - принудительно обновить данные (вызов RAC)
//
// Возвращаемое значение:
//	Массив - список блокировок
//
Функция Список(Отбор = Неопределено, ОбновитьПринудительно = Ложь) Экспорт

	Блокировки = Элементы.Список(Отбор, ОбновитьПринудительно);
	
	Возврат Блокировки;

КонецФункции // Список()

// Функция возвращает список блокировок
//   
// Параметры:
//   ПоляИерархии			- Строка		- Поля для построения иерархии списка блокировок, разделенные ","
//   ОбновитьПринудительно	- Булево		- Истина - принудительно обновить данные (вызов RAC)
//
// Возвращаемое значение:
//	Соответствие - список блокировок
//
Функция ИерархическийСписок(Знач ПоляИерархии, ОбновитьПринудительно = Ложь) Экспорт

	Блокировки = Элементы.ИерархическийСписок(ПоляИерархии, ОбновитьПринудительно);

	Возврат Блокировки;

КонецФункции // ИерархическийСписок()

Лог = Логирование.ПолучитьЛог("ktb.lib.irac");
