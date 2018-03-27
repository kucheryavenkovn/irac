Перем ВариантыИспользованияРабочегоСервера Экспорт;		// Перечисление.ВариантыИспользованияРабочегоСервера
Перем ВариантыИспользованияМенеджераКластера Экспорт;	// Перечисление.ВариантыИспользованияМенеджераКластера
Перем ВариантыРазмещенияСервисов Экспорт;				// Перечисление.ВариантыРазмещенияСервисов
Перем ВклВыкл Экспорт;									// Перечисление.ВклВыкл
Перем ДаНет Экспорт;									// Перечисление.ДаНет
Перем ПраваДоступа Экспорт;								// Перечисление.ПраваДоступа
Перем РежимыРаспределенияНагрузки Экспорт;				// Перечисление.РежимыРаспределенияНагрузки
Перем СпособыАвторизации Экспорт;						// Перечисление.СпособыАвторизации
Перем ТипыСУБД Экспорт;									// Перечисление.ТипыСУБД
Перем Использование Экспорт;							// Перечисление.Использование

// Процедура добавляет значение перечисления в структуру
//   
// Параметры:
//   Перечисление		 	- Структура		- перечисление
//   Имя				 	- Строка		- имя значения перечисления
//   Значение			 	- Строка		- значение перечисления
//
Процедура ДобавитьЗначениеПеречисления(Перечисление, Знач Имя, Знач Значение)
	
	Если НЕ ТипЗнч(Перечисление) = Тип("Структура") Тогда
		Перечисление = Новый Структура();
	КонецЕсли;

	Перечисление.Вставить(Имя, Значение);

КонецПроцедуры // ДобавитьЗначениеПеречисления()

// Процедура инициализирует значения перечислений
//   
Процедура Инициализация()

	// Перечисление.ВариантыИспользованияРабочегоСервера
	ДобавитьЗначениеПеречисления(ВариантыИспользованияРабочегоСервера, "Главный", "main");
	ДобавитьЗначениеПеречисления(ВариантыИспользованияРабочегоСервера, "Обычный", "normal");
	 
	// Перечисление.ВариантыИспользованияМенеджераКластера
	ДобавитьЗначениеПеречисления(ВариантыИспользованияМенеджераКластера, "Обычный", "normal");
	 
	// Перечисление.ВариантыРазмещенияСервисов
	ДобавитьЗначениеПеречисления(ВариантыРазмещенияСервисов, "ВОтдельныхМенеджерах"	, "all");
	ДобавитьЗначениеПеречисления(ВариантыРазмещенияСервисов, "ВОдномМенеджере"		, "none");
	
	// Перечисление.ВклВыкл
	ДобавитьЗначениеПеречисления(ВклВыкл, "Включено"	, "on");
	ДобавитьЗначениеПеречисления(ВклВыкл, "Выключено"	, "off");
	
	// Перечисление.ДаНет
	ДобавитьЗначениеПеречисления(ДаНет, "Да"	, "yes");
	ДобавитьЗначениеПеречисления(ДаНет, "Нет"	, "no");

	// Перечисление.ПраваДоступа
	ДобавитьЗначениеПеречисления(ПраваДоступа, "Разрешено", "allow");
	ДобавитьЗначениеПеречисления(ПраваДоступа, "Запрещено", "deny");

	// Перечисление.РежимыРаспределенияНагрузки
	ДобавитьЗначениеПеречисления(РежимыРаспределенияНагрузки, "ПоПамяти"			, "memory");
	ДобавитьЗначениеПеречисления(РежимыРаспределенияНагрузки, "ПоПроизводительности", "performance");

	// Перечисление.СпособыАвторизации
	ДобавитьЗначениеПеречисления(СпособыАвторизации, "Пароль"	, "pwd");
	ДобавитьЗначениеПеречисления(СпособыАвторизации, "ОС"		, "os");

	// Перечисление.ТипыСУБД
	ДобавитьЗначениеПеречисления(ТипыСУБД, "MSSQLServer"	, "MSSQLServer");
	ДобавитьЗначениеПеречисления(ТипыСУБД, "PostgreSQL"		, "PostgreSQL");
	ДобавитьЗначениеПеречисления(ТипыСУБД, "IBMDB2"			, "IBMDB2");
	ДобавитьЗначениеПеречисления(ТипыСУБД, "OracleDatabase"	, "OracleDatabase");
	
	// Перечисление.Использование
	ДобавитьЗначениеПеречисления(Использование, "Использовать"	, "use");
	
КонецПроцедуры // Инициализация()

Инициализация();