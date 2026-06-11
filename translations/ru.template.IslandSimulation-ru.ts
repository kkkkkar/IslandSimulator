<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE TS>
<TS version="2.1" language="ru">
<context>
    <name>AboutPage</name>
    <message>
        <location filename="../qml/pages/AboutPage.qml" line="21"/>
        <source>About Application</source>
        <translation>&lt;p&gt;&lt;b&gt;О приложении&lt;/b&gt;&lt;br/&gt;
        &lt;b&gt;Версия: 1.0&lt;/b&gt;&lt;br/&gt;
        &lt;b&gt;Автор: Козлова Карина&lt;/b&gt;&lt;br/&gt;</translation>
    </message>
    <message>
        <location filename="../qml/pages/AboutPage.qml" line="31"/>
        <source>#descriptionText</source>
        <translation>&lt;p&gt;«Симулятор острова» — это мобильный симулятор экосистемы для платформы Аврора, реализующий классическую модель взаимодействия «хищник–жертва». Пользователь наблюдает за динамикой популяций волков и кроликов на замкнутой территории 10×14 клеток, может вмешиваться в ход симуляции (пауза, изменение скорости), настраивать начальное количество особей, а после остановки — просматривать график изменения численности.
        &lt;p&gt;Основные возможности:&lt;/p&gt;
        &lt;ol&gt;
                &lt;li&gt;Выбор начального количества кроликов, волков-самцов и волков-самок.&lt;/li&gt;
                &lt;li&gt;Визуализация движения животных по клеткам (случайные блуждания)..&lt;/li&gt;
                &lt;li&gt;Правила симуляции: кролики бессмертны, гибнут только от волков, размножаются с вероятностью 7% каждый шаг при наличии свободной соседней клетки; волки имеют ограниченное кол-во жизней (за 1 шаг тратится 1 жизнь) и размножаются при встрече волка противоположного пола; волки едят кроликов, если оказываются рядом (за что получают доп. жизни).&lt;/li&gt;
                &lt;li&gt;Управление темпом: кнопки «Быстрее», «Медленнее», «Пауза/Воспроизведение».&lt;/li&gt;
                &lt;li&gt;Автоматическая остановка: при перенаселении (&gt;90% клеток занято) или вымирании одного из видов животных.&lt;/li&gt;
                &lt;li&gt;Отображение статистики в реальном времени: количество кроликов, волков-самцов, волков-самок, общее число животных.&lt;/li&gt;
                &lt;li&gt;Кнопка «График» на панели остановки — показывает динамику популяции за всю симуляцию (зелёная линия — кролики, красная — волки).&lt;/li&gt;
        &lt;/ol&gt;</translation>
    </message>
    <message>
        <location filename="../qml/pages/AboutPage.qml" line="36"/>
        <source>3-Clause BSD License</source>
        <translation>Лицензия 3-Clause BSD</translation>
    </message>
    <message>
        <location filename="../qml/pages/AboutPage.qml" line="46"/>
        <source>#licenseText</source>
        <translation>&lt;p&gt;&lt;i&gt;Copyright (C) 2026 ru.template&lt;/i&gt;&lt;/p&gt;
&lt;p&gt;Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:&lt;/p&gt;
&lt;ol&gt;
	&lt;li&gt;Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.&lt;/li&gt;
	&lt;li&gt;Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.&lt;/li&gt;
	&lt;li&gt;Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.&lt;/li&gt;
&lt;/ol&gt;
&lt;p&gt;THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS &quot;AS IS&quot; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.&lt;/p&gt;</translation>
    </message>
</context>
<context>
    <name>DefaultCoverPage</name>
    <message>
        <location filename="../qml/cover/DefaultCoverPage.qml" line="10"/>
        <source>IslandSimulation</source>
        <translation>Симуляция острова</translation>
    </message>
</context>
</TS>
