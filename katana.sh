#!/bin/bash


function pause() {
    read -p "Нажмите Enter для возврата в главное меню..."
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
    echo "2. Запустить пересылку"
    echo "3. Остановить пересылку"
    echo "4. Посмотреть логи"
    echo "5. Выход"
    echo ""
    read -p "Введите номер команды: " choice

      case $choice in
        1)
            echo ""
            echo "=== Авторизация ==="
            read -p "Введите api_id: " api_id
            read -p "Введите api_hash: " api_hash
            read -p "Введите bot (например: @fasol_beta_bot): " bot
            cat <<EOF > profile.txt
api_id='$api_id'
api_hash='$api_hash'
bot='$bot'
EOF
            echo "Файл profile.txt создан."
            chmod ugo+x login
            echo "Запуск ./login..."
            ./login
            pause
            ;;
        2)
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
ExecStart=$CURRENT_DIR/katana_linux
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
        3)
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
        4)
            echo ""
            echo "=== Просмотр логов ==="
            sudo journalctl -u katana -n 100 --no-pager
            pause
            ;;
        5)
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