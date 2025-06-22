// webapp/js/pcas.js
document.addEventListener('DOMContentLoaded', () => {
    const provinceSel = document.getElementById('province');
    const citySel     = document.getElementById('city');
    const distSel     = document.getElementById('district');
    const regionField = document.getElementById('regionField');

    let data = null;

    function fillSelect(sel, items, placeholder) {
        sel.innerHTML = '';
        const opt0 = document.createElement('option');
        opt0.value = '';
        opt0.textContent = placeholder;
        sel.appendChild(opt0);
        for (const key of Object.keys(items)) {
            const opt = document.createElement('option');
            opt.value = key;
            opt.textContent = key;
            sel.appendChild(opt);
        }
        sel.disabled = Object.keys(items).length === 0;
    }

    // 根据你的 JSP 路径调整：如果 addresses.jsp 就在 WebContent 根目录，fetch('./js/pcas.json') 就能取到
    fetch('./js/pcas.json')
        .then(res => res.json())
        .then(json => {
            // 将原始四级数据转换为三级结构：省-市-区
            data = { '省': {}, '市': {}, '区': {} };
            for (const [prov, cities] of Object.entries(json)) {
                data['省'][prov] = true;
                data['市'][prov] = {};
                for (const [city, dists] of Object.entries(cities)) {
                    data['市'][prov][city] = true;
                    data['区'][city] = {};
                    for (const dist of Object.keys(dists)) {
                        data['区'][city][dist] = true;
                    }
                }
            }
            fillSelect(provinceSel, data['省'], '请选择省');
        })
        .catch(err => {
            console.error('加载省市区数据失败：', err);
            alert('无法加载地区数据，请刷新重试');
        });

    provinceSel.addEventListener('change', () => {
        const prov = provinceSel.value;
        const cities = prov && data['市'][prov] ? data['市'][prov] : {};
        fillSelect(citySel, cities, '请选择市');
        fillSelect(distSel, {}, '请选择区');
        regionField.value = '';
    });

    citySel.addEventListener('change', () => {
        const prov = provinceSel.value;
        const city = citySel.value;
        const dists = (prov && city && data['区'][city]) ? data['区'][city] : {};
        fillSelect(distSel, dists, '请选择区');
        regionField.value = '';
    });

    distSel.addEventListener('change', () => {
        const region = [provinceSel, citySel, distSel]
            .map(sel => sel.selectedOptions[0]?.textContent || '')
            .filter(Boolean)
            .join(' ');
        regionField.value = region;
    });

    // 定位按钮改为通过 IP 地址获取大致省市
    document.querySelector('.location-btn')?.addEventListener('click', attemptIPLocation);

    function selectOption(sel, name) {
        for (let o of sel.options) {
            if (name.startsWith(o.text) || o.text.startsWith(name)) { o.selected = true; return true; }
        }
        return false;
    }

    function attemptIPLocation() {
        fetch('https://api.vore.top/api/IPdata')
            .then(res => res.json())
            .then(res => {
                const prov = res.ipdata?.info1 || '';
                const city = res.ipdata?.info2 || '';
                if (selectOption(provinceSel, prov)) {
                    provinceSel.dispatchEvent(new Event('change'));
                    setTimeout(() => {
                        selectOption(citySel, city) || selectOption(citySel, prov);
                        citySel.dispatchEvent(new Event('change'));
                    }, 200);
                }
            })
            .catch(err => console.warn('IP定位失败', err));
    }
});
