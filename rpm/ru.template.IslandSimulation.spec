Name:       ru.template.IslandSimulation
Summary:    Симуляция острова с волками и кроликами
Version:    1.0
Release:    1
License:    BSD-3-Clause
URL:        https://auroraos.ru
Source0:    %{name}-%{version}.tar.bz2

Requires:   sailfishsilica-qt5 >= 0.10.9
BuildRequires:  pkgconfig(auroraapp)
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)

%description
Симулятор острова» — это мобильный симулятор экосистемы для платформы Аврора, реализующий классическую модель взаимодействия «хищник–жертва». Пользователь наблюдает за динамикой популяций волков и кроликов на замкнутой территории 10×14 клеток, может вмешиваться в ход симуляции (пауза, изменение скорости), настраивать начальное количество особей, а после остановки — просматривать график изменения численности.

%prep
%autosetup

%build
%qmake5
%make_build

%install
%make_install

%files
%defattr(-,root,root,-)
%{_bindir}/%{name}
%defattr(644,root,root,-)
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
