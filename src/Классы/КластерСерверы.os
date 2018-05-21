Перем Кластер_Агент;
Перем Кластер_Владелец;
Перем ПараметрыОбъекта;
Перем Элементы;

Перем Лог;

// Конструктор
//   
// Параметры:
//   АгентКластера		- АгентКластера	- ссылка на родительский объект агента кластера
//   Кластер			- Кластер		- ссылка на родительский объект кластера
//
Процедура ПриСозданииОбъекта(АгентКластера, Кластер)

	Кластер_Агент = АгентКластера;
	Кластер_Владелец = Кластер;

	ПараметрыОбъекта = Новый ПараметрыОбъекта("server");

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

	ПараметрыЗапуска.Добавить("server");
	ПараметрыЗапуска.Добавить("list");

	ПараметрыЗапуска.Добавить(СтрШаблон("--cluster=%1", Кластер_Владелец.Ид()));
	ПараметрыЗапуска.Добавить(Кластер_Владелец.СтрокаАвторизации());

	Кластер_Агент.ВыполнитьКоманду(ПараметрыЗапуска);
	
	МассивРезультатов = Кластер_Агент.ВыводКоманды();

	МассивСерверов = Новый Массив();
	Для Каждого ТекОписание Из МассивРезультатов Цикл
		МассивСерверов.Добавить(Новый Сервер(Кластер_Агент, Кластер_Владелец, ТекОписание));
	КонецЦикла;

	Элементы.Заполнить(МассивСерверов);

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

// Функция возвращает список серверов кластера 1С
//   
// Параметры:
//   Отбор					 	- Структура	- Структура отбора серверов (<поле>:<значение>)
//   ОбновитьПринудительно 		- Булево	- Истина - принудительно обновить данные (вызов RAC)
//
// Возвращаемое значение:
//	Массив - список серверов кластера 1С
//
Функция Список(Отбор = Неопределено, ОбновитьПринудительно = Ложь) Экспорт

	СписокСерверов = Элементы.Список(Отбор, ОбновитьПринудительно);
	
	Возврат СписокСерверов;

КонецФункции // Список()

// Функция возвращает список серверов кластера 1С
//   
// Параметры:
//   ПоляИерархии 			- Строка		- Поля для построения иерархии списка серверов, разделенные ","
//   ОбновитьПринудительно 	- Булево		- Истина - обновить список (вызов RAC)
//
// Возвращаемое значение:
//	Соответствие - список серверов кластера 1С
//		<имя поля объекта>	- Массив(Соответствие), Соответствие	- список серверов или следующий уровень
//
Функция ИерархическийСписок(Знач ПоляИерархии, ОбновитьПринудительно = Ложь) Экспорт

	СписокКластеров = Элементы.ИерархическийСписок(ПоляИерархии, ОбновитьПринудительно);
	
	Возврат СписокКластеров;

КонецФункции // ИерархическийСписок()

// Функция возвращает количество серверов в списке
//   
// Возвращаемое значение:
//	Число - количество серверов
//
Функция Количество() Экспорт

	Если Элементы = Неопределено Тогда
		Возврат 0;
	КонецЕсли;
	
	Возврат Элементы.Количество();

КонецФункции // Количество()

// Функция возвращает описание сервера кластера 1С
//   
// Параметры:
//   ИмяСервера	 			- Строка	- Имя сервера в кластере
//   ОбновитьПринудительно 	- Булево	- Истина - принудительно обновить данные (вызов RAC)
//
// Возвращаемое значение:
//	Соответствие - описание сервера кластера 1С
//
Функция Получить(Знач ИмяСервера, Знач ОбновитьПринудительно = Ложь) Экспорт

	Отбор = Новый Соответствие();
	Отбор.Вставить("name", ИмяСервера);

	СписокСерверов = Элементы.Список(Отбор, ОбновитьПринудительно);
	
	Если СписокСерверов.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат СписокСерверов[0];

КонецФункции // Получить()

// Процедура добавляет новый сервер в кластер 1С
//   
// Параметры:
//   Имя			 	- Строка		- имя сервера 1С
//   АдресСервера	 	- Строка		- адрес сервера 1С
//   ПортСервера	 	- Число			- порт сервера 1С
//   ПараметрыСервера 	- Структура		- параметры сервера 1С
//
Процедура Добавить(Имя, АдресСервера = "localhost", ПортСервера = 1541, ПараметрыСервера = Неопределено) Экспорт

	ПараметрыЗапуска = Новый Массив();
	ПараметрыЗапуска.Добавить(Кластер_Агент.СтрокаПодключения());

	ПараметрыЗапуска.Добавить("server");
	ПараметрыЗапуска.Добавить("insert");

	ПараметрыЗапуска.Добавить(СтрШаблон("--cluster=%1", Кластер_Владелец.Ид()));
	ПараметрыЗапуска.Добавить(Кластер_Владелец.СтрокаАвторизации());

	ПараметрыЗапуска.Добавить(СтрШаблон("--agent-host=%1", АдресСервера));
	ПараметрыЗапуска.Добавить(СтрШаблон("--agent-port=%1", ПортСервера));
	ПараметрыЗапуска.Добавить(СтрШаблон("--name=%1", Имя));

	ВремПараметры = ПараметрыОбъекта();

	Для Каждого ТекЭлемент Из ВремПараметры Цикл
		ЗначениеПараметра = Служебный.ПолучитьЗначениеИзСтруктуры(ПараметрыСервера, ТекЭлемент.Ключ, 0);
		ПараметрыЗапуска.Добавить(СтрШаблон(ТекЭлемент.Значение.ПараметрКоманды + "=%1", ЗначениеПараметра));
	КонецЦикла;

	Кластер_Агент.ВыполнитьКоманду(ПараметрыЗапуска);
	
	Лог.Информация(Кластер_Агент.ВыводКоманды());

	ОбновитьДанные();

КонецПроцедуры // Добавить()

// Процедура удаляет сервер из кластера 1С
//   
// Параметры:
//   СерверПорт			- Строка	- Адрес сервера в виде <сервер>:<порт>
//
Процедура Удалить(СерверПорт) Экспорт
	
	ПараметрыЗапуска = Новый Массив();
	ПараметрыЗапуска.Добавить(Кластер_Агент.СтрокаПодключения());

	ПараметрыЗапуска.Добавить("server");
	ПараметрыЗапуска.Добавить("remove");

	ПараметрыЗапуска.Добавить(СтрШаблон("--server=%1", Получить(СерверПорт).Ид()));

	ПараметрыЗапуска.Добавить(СтрШаблон("--cluster=%1", Кластер_Владелец.Ид()));
	ПараметрыЗапуска.Добавить(Получить(СерверПорт).СтрокаАвторизации());
	
	Кластер_Агент.ВыполнитьКоманду(ПараметрыЗапуска);
	
	Лог.Информация(Кластер_Агент.ВыводКоманды());

	ОбновитьДанные();

КонецПроцедуры // Удалить()

Лог = Логирование.ПолучитьЛог("ktb.lib.irac");
