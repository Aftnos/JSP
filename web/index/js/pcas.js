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
            data = json;
            fillSelect(provinceSel, data['省'] || {}, '请选择省');
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

    // 定位按钮
    document.querySelector('.location-btn')?.addEventListener('click', () => {
        if (!navigator.geolocation) {
            return alert('浏览器不支持定位');
        }
        navigator.geolocation.getCurrentPosition(position => {
            const { latitude, longitude } = position.coords;
            // 这里用高德逆地理（需先在 <head> 引入 amap js API）
            const geocoder = new AMap.Geocoder({ city: '' });
            geocoder.getAddress([longitude, latitude], (status, result) => {
                if (status === 'complete' && result.regeocode) {
                    const comp = result.regeocode.addressComponent;
                    // 依次选中：省
                    for (let o of provinceSel.options) {
                        if (o.text === comp.province) { o.selected = true; break; }
                    }
                    provinceSel.dispatchEvent(new Event('change'));

                    // 选中市
                    setTimeout(() => {
                        for (let o of citySel.options) {
                            if (o.text === (comp.city || comp.province)) { o.selected = true; break; }
                        }
                        citySel.dispatchEvent(new Event('change'));
                    }, 200);

                    // 选中区
                    setTimeout(() => {
                        for (let o of distSel.options) {
                            if (o.text === comp.district) { o.selected = true; break; }
                        }
                        distSel.dispatchEvent(new Event('change'));
                    }, 400);
                } else {
                    alert('逆地理编码失败，请稍后重试');
                }
            });
        }, err => {
            alert('定位失败：' + err.message);
        }, { enableHighAccuracy: true, timeout: 5000 });
    });
});
