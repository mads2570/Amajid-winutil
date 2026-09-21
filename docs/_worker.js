export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const userAgent = (request.headers.get("user-agent") || "").toLowerCase();

    // If path is /win or request is made from PowerShell / curl / irm
    if (url.pathname === "/win" || url.pathname === "/win/" || userAgent.includes("powershell") || userAgent.includes("curl") || userAgent.includes("wget")) {
      const scriptUrl = "https://raw.githubusercontent.com/mads2570/Amajid-winutil/main/docs/win";
      const resp = await fetch(scriptUrl);
      const text = await resp.text();
      return new Response(text, {
        headers: {
          "content-type": "text/plain; charset=utf-8",
          "cache-control": "no-cache, no-store, must-revalidate"
        }
      });
    }

    // Default redirect to github repository
    return Response.redirect("https://github.com/mads2570/Amajid-winutil", 302);
  }
};
