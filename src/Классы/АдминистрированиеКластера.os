Перем Админ_АдресСервера;
Перем Админ_ПортСервера;
Перем Агент_ИсполнительКоманд;
Перем Агент_Администраторы;
Перем Агент_Администратор;
Перем ВыводКоманды;
Перем Кластеры;
Перем Лог;

Перем мОбработчикОшибок;

// Конструктор
//   
// Параметры:
//   АдресСервера			- Строка	- имя сервера агента администрирования (RAS)
//   ПортСервера			- Число		- порт сервера агента администрирования (RAS)
//   ВерсияИлиПутьКРАК		- Строка	- маска версии 1С или путь к утилите RAC
//   Администратор 			- Строка	- администратор агента сервера 1С
//   ПарольАдминистратора 	- Строка	- пароль администратора агента сервера 1С
//
Процедура ПриСозданииОбъекта(АдресСервера
						   , ПортСервера
						   , ВерсияИлиПутьКРАК = "8.3"
						   , Администратор = ""
						   , ПарольАдминистратора = "")

	Админ_АдресСервера = АдресСервера;
	Админ_ПортСервера = ПортСервера;
	
	Агент_ИсполнительКоманд = Новый ИсполнительКоманд(ВерсияИлиПутьКРАК);

	Если ЗначениеЗаполнено(Администратор) Тогда
		Агент_Администратор = Новый Структура("Администратор, Пароль", Администратор, ПарольАдминистратора);
	Иначе
		Агент_Администратор = Неопределено;
	КонецЕсли;
	
	Агент_Администраторы = Новый АдминистраторыАгента(ЭтотОбъект);
	Кластеры = Новый Кластеры(ЭтотОбъект);

КонецПроцедуры // ПриСозданииОбъекта()

// Функция возвращает строку параметров подключения к агенту администрирования (RAS)
//   
// Возвращаемое значение:
//	Строка - строка параметров подключения к агенту администрирования (RAS)
//
Функция СтрокаПодключения() Экспорт

	Лог.Отладка("Сервер " + Админ_АдресСервера);
	Лог.Отладка("Порт <" + Админ_ПортСервера + ">");

	Сервер = "";
	Если Не ПустаяСтрока(Админ_АдресСервера) Тогда
		Сервер = Админ_АдресСервера;
		Если Не ПустаяСтрока(Админ_ПортСервера) Тогда
			Сервер = Сервер + ":" + Админ_ПортСервера;
		КонецЕсли;
	КонецЕсли;
			
	Возврат Сервер;

КонецФункции // СтрокаПодключения()

// Функция возвращает строку параметров авторизации на агенте кластера 1С
//   
// Возвращаемое значение:
//	Строка - строка параметров авторизации на агенте кластера 1С
//
Функция СтрокаАвторизации() Экспорт
	
	Если НЕ ТипЗнч(Агент_Администратор)  = Тип("Структура") Тогда
		Возврат "";
	КонецЕсли;

	Если НЕ Агент_Администратор.Свойство("Администратор") Тогда
		Возврат "";
	КонецЕсли;

	Лог.Отладка("Администратор " + Агент_Администратор.Администратор);
	Лог.Отладка("Пароль <***>");

	СтрокаАвторизации = "";
	Если Не ПустаяСтрока(Агент_Администратор.Администратор) Тогда
		СтрокаАвторизации = СтрШаблон("--agent-user=%1",Агент_Администратор.Администратор);
	КонецЕсли;

	Если Не ПустаяСтрока(Агент_Администратор.Пароль) Тогда
		СтрокаАвторизации = СтрокаАвторизации + СтрШаблон("--agent-pwd=%1", Агент_Администратор.Пароль);
	КонецЕсли;
			
	Возврат СтрокаАвторизации;
	
КонецФункции // СтрокаАвторизации()
	
// Процедура устанавливает параметры авторизации на агенте кластера 1С
//   
// Параметры:
//   Администратор 		- Строка	- администратор агента сервера 1С
//   Пароль			 	- Строка	- пароль администратора агента сервера 1С
//
Процедура УстановитьАдминистратора(Администратор, Пароль) Экспорт

	Агент_Администратор = Новый Структура("Администратор, Пароль", Администратор, Пароль);

КонецПроцедуры // УстановитьАдминистратора()

// Функция возвращает текущий объект-исполнитель команд
//   
// Возвращаемое значение:
//   ИсполнительКоманд		- текущее значение объекта-исполнителя команд
//
Функция ИсполнительКоманд() Экспорт

	Возврат Агент_ИсполнительКоманд;

КонецФункции // ИсполнительКоманд()

// Процедура устанавливает объект-исполнитель команд
//   
// Параметры:
//   НовыйИсполнитель 		- ИсполнительКоманд		- новый объект-исполнитель команд
//
Процедура УстановитьИсполнительКоманд(Знач НовыйИсполнитель = Неопределено) Экспорт

	Агент_ИсполнительКоманд = НовыйИсполнитель;

КонецПроцедуры // УстановитьИсполнительКоманд()

// Устанавливает объект-обработчик, который будет вызываться в случае неудачи вызова ИсполнителяКоманд.
// Объект обработчик должен определить метод ОбработатьОшибку с параметрами:
//   * ПараметрыКоманды - передадутся параметры вызванной команды
//   * АгентАдминистрирования - объект АдминистрированиеКластера у которого вызывалась команда
//   * КодВозврата - на входе - полученный код возврата команды. В качестве выходного параметра 
//                   можно присвоить новое значение кода возврата
//
// Параметры:
//   НовыйОбработчикОшибок - объект-обработчик
//
Процедура УстановитьОбработчикОшибокКоманд(Знач НовыйОбработчикОшибок) Экспорт
	мОбработчикОшибок = НовыйОбработчикОшибок;
КонецПроцедуры

// Функция выполняет команду и возвращает код возврата команды
//   
// Параметры:
//   ПараметрыКоманды 		- Массив		- параметры выполнения команды
//
// Возвращаемое значение:
//   Число			 		- Код возврата команды
//
Функция ВыполнитьКоманду(ПараметрыКоманды) Экспорт

	ВыводКоманды = Агент_ИсполнительКоманд.ВыполнитьКоманду(ПараметрыКоманды);
	ПолученныйКод = Агент_ИсполнительКоманд.КодВозврата();

	Если ПолученныйКод <> 0 и мОбработчикОшибок <> Неопределено Тогда
		мОбработчикОшибок.ОбработатьОшибку(ПараметрыКоманды, ЭтотОбъект, ПолученныйКод);
	КонецЕсли;

	Возврат ПолученныйКод;

КонецФункции // ВыполнитьКоманду()

// Функция возвращает текст результата выполнения команды
//   
// Параметры:
//	РазобратьВывод		- Булево 		- Истина - выполнить преобразование вывода команды в структуру
//										  Ложь - вернуть текст вывода команды как есть
//
// Возвращаемое значение:
//	Структура, Строка	- вывод команды
//
Функция ВыводКоманды(РазобратьВывод = Истина) Экспорт

	Если РазобратьВывод Тогда
		Возврат РазобратьВыводКоманды(ВыводКоманды);
	КонецЕсли;

	Возврат ВыводКоманды;

КонецФункции // ВыводКоманды()

// Функция возвращает код возврата выполнения команды
//   
// Возвращаемое значение:
//	Число - код возврата команды
//
Функция КодВозврата() Экспорт

	Возврат Агент_ИсполнительКоманд.КодВозврата();

КонецФункции // КодВозврата()

// Функция преобразует переданный текст вывода команды в массив соответствий
// элементы массива создаются по блокам текста, разделенным пустой строкой
// пары <ключ, значение> структуры получаются для каждой строки с учетом разделителя ":"
//   
// Параметры:
//   ВыводКоманды			- Строка			- текст для разбора
//   
// Возвращаемое значение:
//	Массив (Соответствие) - результат разбора
//
Функция РазобратьВыводКоманды(Знач ВыводКоманды)
	
	Текст = Новый ТекстовыйДокумент();
	Текст.УстановитьТекст(ВыводКоманды);

	МассивРезультатов = Новый Массив();
	Описание = Новый Соответствие();

	Для й = 1 По Текст.КоличествоСтрок() Цикл

		ТекстСтроки = Текст.ПолучитьСтроку(й);
		
		ПозРазделителя = СтрНайти(ТекстСтроки, ":");

		Если НЕ ЗначениеЗаполнено(ТекстСтроки) Тогда
			Если й = 1 Тогда
				Продолжить;
			КонецЕсли;
			МассивРезультатов.Добавить(Описание);
			Описание = Новый Соответствие();
			Продолжить;
		ИначеЕсли ПозРазделителя = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Описание.Вставить(СокрЛП(Лев(ТекстСтроки, ПозРазделителя - 1)), СокрЛП(Сред(ТекстСтроки, ПозРазделителя + 1)));

	КонецЦикла;

	Возврат МассивРезультатов;

КонецФункции // РазобратьВыводКоманды()

// Функция возвращает строку описания подключения к серверу администрирования кластера 1С
//   
// Возвращаемое значение:
//	Строка - описание подключения к серверу администрирования кластера 1С
//
Функция ОписаниеПодключения() Экспорт

	Возврат СокрЛП(Админ_АдресСервера) + ":" + Формат(Админ_ПортСервера, "ЧГ=") +
			" (v." + СокрЛП(Агент_ИсполнительКоманд.ВерсияУтилитыАдминистрирования()) + ")";

КонецФункции // ОписаниеПодключения()

// Функция возвращает список администраторов агента кластера 1С
//   
// Возвращаемое значение:
//	Агент_Администраторы - список администраторов агента кластера 1С
//
Функция Администраторы() Экспорт

	Возврат Агент_Администраторы;

КонецФункции // Администраторы()

// Функция возвращает список кластеров 1С
//   
// Возвращаемое значение:
//	Кластеры - список кластеров 1С
//
Функция Кластеры() Экспорт

	Возврат Кластеры;

КонецФункции // Кластеры()	

Лог = Логирование.ПолучитьЛог("ktb.lib.irac");
