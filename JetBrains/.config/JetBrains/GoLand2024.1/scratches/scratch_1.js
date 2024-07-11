import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
    vus: 500,           // Количество виртуальных пользователей
    iterations: 5000,   // Количество итераций на одного пользователя
};

// Массив sessionTokens
const sessionTokens = ["e80d1c7e-193c-47f6-b42a-35150f87654b"]

export default function () {
    const userId = __VU;       // ID виртуального пользователя
    const sessionToken = sessionTokens[userId - 1];  // Получение sessionToken

    console.log(`WAGer User ${userId}: Using sessionToken ${sessionToken}`);

    // Первый запрос к /wager
    const payload1 = JSON.stringify({
        "currency": "usd",
        "session_token": sessionToken,
        "wager": 200,
        "engine_params": {
            "ante_bet": false
        }
    });

    const params = {
        headers: {
            "content-type": "application/json",
            "origin": "https://prod-games.18peaches.games"
        },
    };

    // console.log(`User ${userId}: Sending /wager request`);
    let res1 = http.post('https://prod-games.18peaches.games/lucky-skulls-bonanza/api/core/wager', payload1, params);
    if (res1.status !== 200) {
        console.log(`User ${userId}: Wager API ERROR. Response status: ${res1.status}Response body: ${res1.body}`);
    }
    sleep(1); // Задержка между запросами

    // Второй запрос к /spin_indexes/update
    const payload2 = JSON.stringify({
        "restoring_indexes": {
            "base_spin_index": 1,
            "bonus_spin_index": 0
        },
        "session_token": sessionToken
    });

    console.log(`Update User ${userId}: Using sessionToken ${sessionToken}`);

    // console.log(`User ${userId}: Sending /spin_indexes/update request`);
    let res2 = http.post('https://prod-games.18peaches.games/lucky-skulls-bonanza/api/core/spin_indexes/update', payload2, params);
    if (res2.status !== 200) {
        console.log(`User ${userId}: Update API ERROR. Response status: ${res2.status} Response body: ${res2.body}`);
    }
    sleep(1); // Задержка перед следующим циклом
}
