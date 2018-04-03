# Библиотека управления кластером 1С
[![Build Status](https://travis-ci.org/arkuznetsov/irac.svg?branch=develop)](https://travis-ci.org/arkuznetsov/irac)
[![Quality Gate](https://sonar.silverbulleters.org/api/badges/gate?key=opensource-irac)](https://sonar.silverbulleters.org/dashboard/index/opensource-irac)
[![Coverage](https://sonar.silverbulleters.org/api/badges/measure?key=opensource-irac&metric=coverage)](https://sonar.silverbulleters.org/dashboard/index/opensource-irac)
[![Tech debt](https://sonar.silverbulleters.org/api/badges/measure?key=opensource-irac&metric=sqale_debt_ratio)](https://sonar.silverbulleters.org/dashboard/index/opensource-irac)

## Назначение

Библиотека (oscript) irac предоставляет интерфейс управления кластером серверов 1С:Предприятие 8 с использованием утилиты администрирования кластера (RAC).


## Принцип работы

Библиотека подключается, как отдельный класс и используется для вызова команд утилиты RAC для взаимодействия с одним экземпляром сервера администрирования кластера 1С.

```bsl
#Использовать irac
Админка = Новый АдминистрированиеКластера("localhost", 1545);

Кластеры = Админка.Кластеры();

// Обходим список кластеров
Для Каждого Кластер Из Кластеры.Список() Цикл
    Сообщить(Кластер.Получить("Имя"));
КонецЦикла;

Серверы = Кластер.Серверы();

// Обходим список серверов
Для Каждого Сервер Из Серверы.Список() Цикл

    Сообщить(Сервер.Имя() + " (" + Сервер.АдресСервера() + ":" + Сервер.ПортСервера() + ")");

    Для Каждого ТекАтрибут Из Серверы.ПолучитьСтруктуруПараметровОбъекта() Цикл
        Сообщить(ТекАтрибут.Ключ + " : " + Сервер.Получить(ТекАтрибут.Значение.ИмяПараметра));
    КонецЦикла;

КонецЦикла;

ИБ = Кластер.ИнформационныеБазы();

Сообщить("Всего ИБ: " + ИБ.Список().Количество());

// Обходим список информационных баз
Для Каждого ТекИБ Из ИБ.Список() Цикл

    Сообщить(ТекИБ.Имя() + " (" + ?(ТекИБ.ПолноеОписание(), "Полное", "Сокращенное") + " " + ТекИБ.Описание() + ")");

    Для Каждого ТекАтрибут Из ИБ.ПолучитьСтруктуруПараметровОбъекта() Цикл
        Сообщить(ТекАтрибут.Ключ + " : " + ТекИБ.Получить(ТекАтрибут.Значение.ИмяПараметра));
    КонецЦикла;

КонецЦикла;

```

АдминистрированиеКластера
    
    |-Администраторы
    |-Кластеры
    |   |-Администраторы
    |   |-МенеджерыКластера
    |   |-Серверы
    |   |   |-ТребованияНазначения
    |   |-РабочиеПроцессы
    |   |   |-Лицензии
    |   |-ИнформационныеБазы
    |   |-Сервисы
    |   |-Сеансы
    |   |-Соединения
    |   |   |-Лицензии
    |   |-Блокировки
    |   |-ПрофилиБезопасности