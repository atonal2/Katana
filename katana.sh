#!/bin/bash

function pause() {
    read -p "Нажмите Enter для возврата в главное меню..."
}

# Функция для отображения выбранных веток
function show_selected_branches() {
    if [ -f "profile.txt" ]; then
        selected_branches=$(grep -oP "reply=\K[^\n]+" profile.txt)
        if [ -n "$selected_branches" ]; then
            echo "Текущие выбранные ветки:"
            echo "$selected_branches" | tr ',' '\n'  # Переводим на новую строку
        else
            echo "Нет выбранных веток."
        fi
    else
        echo "Нет настроек в profile.txt."
    fi
}

# Функция для обновления значений в profile.txt
function update_profile() {
    local key=$1
    local value=$2
    if grep -q "^$key=" profile.txt; then
        # Если ключ существует, заменяем его значение
        sed -i "s|^$key=.*|$key='$value'|" profile.txt
    else
        # Если ключа нет, добавляем строку в конец файла
        echo "$key='$value'" >> profile.txt
    fi
}

# Функция для обновления выбранных веток в profile.txt
function update_branches() {
    if [ -n "$1" ]; then
        # Оставляем строку "reply=" и обновляем её значениями
        sed -i "/^reply=/c\reply=$1" profile.txt
        echo "Выбранные ветки обновлены."
    else
        # Если пустой ввод, то оставляем только "reply=" (удаляем все значения)
        sed -i "/^reply=/c\reply=" profile.txt
        echo "Ветки удалены."
    fi
}

# Функция для удаления всех веток
function remove_all_branches() {
    # Убираем все значения из поля reply, оставляя только "reply="
    sed -i "/^reply=/c\reply=" profile.txt
    echo "Все ветки удалены."
}

# Функция для перезапуска службы katana
function restart_service() {
    echo "Перезапуск службы katana..."
    sudo systemctl restart katana
    echo "Служба katana перезапущена."
}

while true; do
    clear
    echo "===================================================================="
    echo "    #   #   #####   #####    #####   #   #    #####"
    echo "    #  #   #     #    #     #     #  ##  #   #     #"
    echo "    ###    #######    #     #######  # # #   #######"
    echo "    #  #   #     #    #     #     #  #  ##   #     #"
    echo "    #   #  #     #    #     #     #  #   #   #     #"
    echo ""
    echo "       KATANA - Скрипт управления пересылкой сообщений"
    echo "                  t.me/bsdktn"
    echo "===================================================================="
    echo ""
    echo "Выберите команду:"
    echo "1. Залогиниться"
    echo "2. Выбрать ветки"
    echo "3. Запустить пересылку"
    echo "4. Остановить пересылку"
    echo "5. Перезапуск службы"
    echo "6. Посмотреть логи"
    echo "7. Выход"
    echo ""
    read -p "Введите номер команды: " choice

    case $choice in
        1)
            echo ""
            echo "=== Авторизация ==="
            read -p "Введите api_id: " api_id
            read -p "Введите api_hash: " api_hash
            read -p "Введите bot (например: @fasol_beta_bot): " bot

            # Обновляем файл profile.txt
            update_profile "api_id" "$api_id"
            update_profile "api_hash" "$api_hash"
            update_profile "bot" "$bot"

            echo "Файл profile.txt обновлен."
            chmod ugo+x login1
            echo "Запуск ./login1..."
            ./login1
            pause
            ;;
        2)
            echo ""
            echo "=== Выбор веток ==="
            # Отобразим список доступных веток
            echo "Доступные ветки:"
            echo "1 - PonziPaid"
            echo "2 - Medium risk"
            echo "3 - KOL vision"
            echo "4 - High risk"
            echo ""

            # Показать выбранные ветки
            show_selected_branches
            echo ""

            # Информация о перезаписи выбранных веток
            echo "Внимание: выбранные ветки будут перезаписаны!"

            # Даем пользователю возможность выбрать/удалить ветки
            read -p "Введите номера веток, которые хотите выбрать (через запятую, например: 1,3) или нажмите Enter, 
чтобы оставить без изменений, или введите 0, чтобы удалить все ветки: " selected

            if [ "$selected" == "0" ]; then
                # Удалить все ветки
                remove_all_branches
            elif [ -z "$selected" ]; then
                # Если пустой ввод, оставляем текущие ветки
                selected=$(grep -oP "reply=\K[^\n]+" profile.txt)
                echo "Вы не выбрали новые ветки. Текущие ветки сохранены."
                update_branches "$selected"
            else
                # Обновляем файл profile.txt
                update_branches "$selected"
            fi
            pause
            ;;
        3)
            echo ""
            echo "=== Запуск пересылки ==="
            SERVICE_FILE="/etc/systemd/system/katana.service"
            CURRENT_DIR=$(readlink -f .)
            USER_NAME=$(whoami)
            if [ ! -f "$SERVICE_FILE" ]; then
                echo "Служба katana не найдена. Создание службы..."
                sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Katana forwarding service
After=network.target

[Service]
Type=simple
WorkingDirectory=$CURRENT_DIR
ExecStart=$CURRENT_DIR/katana_linux1
Restart=always
User=$USER_NAME

[Install]
WantedBy=multi-user.target
EOF
                sudo systemctl daemon-reload
                sudo systemctl enable katana
                echo "Служба katana создана и включена."
            fi
            sudo systemctl start katana
            echo "Пересылка запущена."
            pause
            ;;
        4)
            echo ""
            echo "=== Остановка пересылки и удаление службы ==="
            sudo systemctl stop katana
            sudo systemctl disable katana
            SERVICE_FILE="/etc/systemd/system/katana.service"
            if [ -f "$SERVICE_FILE" ]; then
                sudo rm "$SERVICE_FILE"
                sudo systemctl daemon-reload
                echo "Служба katana удалена."
            else
                echo "Служба katana не найдена."
            fi
            echo "Пересылка остановлена."
            pause
            ;;
        5)
            echo ""
            echo "=== Перезапуск службы ==="
            restart_service
            pause
            ;;
        6)
            echo ""
            echo "=== Просмотр логов ==="
            sudo journalctl -u katana -n 100 --no-pager
            pause
            ;;
        7)
            echo ""
            echo "Выход..."
            exit 0
            ;;
        *)
            echo "Неверная команда, попробуйте снова."
            pause
            ;;
    esac
done
