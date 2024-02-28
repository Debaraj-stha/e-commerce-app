document.addEventListener("DOMContentLoaded", function () {
  const containers = document.querySelectorAll("section");
  function handleScroll() {
    containers.forEach((element) => {
      let boxHeight = element.getBoundingClientRect().top;

      if (boxHeight < window.innerHeight) {
        element.classList.add("animate");
      }
    });
  }

  window.addEventListener("scroll", handleScroll);
  handleScroll();
});

async function submitForm() {
  let message = document.getElementById("message").value;

  let url = new URL(window.location);

  let urlSearchParam = new URLSearchParams(url.search);

  let shopId = urlSearchParam.get("shop_id");
  let userId = urlSearchParam.get("user_id");

  let data = {
    message: message,
    shopId: shopId,
    userId: userId,
  };

  let response = await sendXMLRequest(
    "POST",
    "http://localhost:8000/send/reply",
    data
  );
  console.log(response);
}
async function registerShop() {
  let address = document.getElementById("address").value;
  let phone = document.getElementById("phone").value;
  let name = document.getElementById("shopName").value;

  let shopDetails = {
    address: address,
    phone: phone,
    name: name,
  };

  let response = await sendXMLRequest(
    "POST",
    "http://localhost:8000/register/shop",
    shopDetails
  );
  let jsonResponse = JSON.parse(response);
  alert(jsonResponse["message"]);
  if (jsonResponse["status"]) {
    address = "";
    name = "";
    phone = "";
  }
  console.log(jsonResponse);
}
function sendXMLRequest(method, url, data) {
  let xhttp = new XMLHttpRequest();

  xhttp.onreadystatechange = function () {
    if (this.readyState == 4 && xhttp.status == 200) {
      if (data["name"] != null || data["name"] != undefined) {
        localStorage.setItem("shop", JSON.stringify(data));
      }
      console.log(xhttp.responseText);
      return xhttp.response;
    }
  };

  xhttp.open(method, url, true);
  xhttp.setRequestHeader("Content-Type", "application/json");
  xhttp.send(JSON.stringify(data));
}
window.onload = function () {
  let wrapper = document.getElementById("shop_name_wrapper");
  let register_link = document.getElementById("register_link");
  let shopDetails = localStorage.getItem("shop");
  console.log("loading...");
  if (shopDetails != null || shopDetails != undefined) {
    register_link.classList.add("d-none");
    let shop = JSON.parse(shopDetails);
    wrapper.innerText = shop.name;
  } else {
    window.location.href = "/shop/register";
  }
};
