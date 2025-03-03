# Katana

**KATANA** – репозиторий содержит инструменты для запуска и остановки пересылки приватного чата KATANA, просмотра логов и авторизации через Telegram API.

---

## Перед началом

1. **Получите свои API данные:**

   Перейдите по [этой ссылке](https://my.telegram.org/auth) и получите свой `api_id` и `api_hash`.

2. **Аренда сервера:**

   Если у вас еще нет сервера, арендуйте самый простой сервер за 5$ на [Aeza](https://aeza.net/?ref=583653).  
   Скопируйте оттуда IP и пароль для подключения.

3. **Подключение к серверу:**

   Если вы работаете с телефона, скачайте [Termius](https://termius.com/) для удобного SSH-подключения.  
   Если вы работаете с компьютера, можете использовать любой SSH-клиент, добавьте IP и пароль вашего сервера, но так же можете скачать [Termius](https://termius.com/) для удобного SSH-подключения.

---

## Установка и запуск

Чтобы установить и запустить Katana, выполните следующую команду в терминале на серевере:

```bash
sudo bash -c  'git clone https://github.com/atonal2/Katana.git && cd Katana && chmod +x katana.sh && ./katana.sh'
```

## После этого откроется меню с выбором команды:

      Выберите команду:
      1. Залогиниться
      2. Запустить пересылку
      3. Остановить пересылку
      4. Посмотреть логи
      5. Выход

## Инструкция по использованию

### 1. Залогиниться

При выборе этой команды:
- Вам будет предложено ввести ваш номер телефона.
- Введите код подтверждения, который вы получите.
- Если у вас настроен облачный пароль, введите его.
- Укажите, куда будет пересылаться (введите имя бота, например: `@fasol_beta_bot`).

### 2. Запустить пересылку

- После успешной авторизации выберите команду **“Запустить пересылку”**.
- Скрипт создаст службу, запустит пересылку и начнет работу бота.

### 3. Остановить пересылку

- Для остановки пересылки выберите команду **“Остановить пересылку”**.
- При этом служба будет остановлена и удалена из systemd.

### 4. Посмотреть логи

- Команда **“Посмотреть логи”** выведет последние 100 записей из журнала службы, что позволит вам отслеживать работу бота.

### 5. Выход

- Выберите команду **“Выход”** чтоб выйти из управления программы, нужно заметить если вы выходите, то пересылка не выключается, если хотите выключить выполните команду **"3. Остановить пересылку"**.

---

**Примечание:**  
Для повторного вызова скрипта, если он уже установлен, используйте:

```bash
cd Katana && ./katana.sh
```

## Локальный запуск (решение 2)

Если вы хотите запустить пересылку локально на своем компьютере Windows:

1. Скачайте этот репозиторий локально https://github.com/atonal2/Katana/archive/refs/heads/main.zip.
2. Откройте файл `profile.txt` и замените данные на свои (`api_id`, `api_hash` и имя бота).
3. Запустите файл `katana_win.exe`:
   - Вам будет предложено ввести номер телефона, код подтверждения и облачный пароль (если он установлен).
   - После успешной авторизации пересылка будет запущена.
4. Для остановки пересылки просто закройте программу.
